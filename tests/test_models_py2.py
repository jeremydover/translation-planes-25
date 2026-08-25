#!/usr/bin/env python
"""Python 2.4-compatible Magma model regression harness.

No third-party modules are required. Run from the dataset root:

    python test_models_py2.py

or:

    python test_models_py2.py --magma magma.exe

The harness reads planes.jsonl, sources.jsonl and models.jsonl, generates one
Magma script per model record under .test-harness/generated, and runs each
script through ``magma -b`` using stdin.
"""

import getopt
import os
import re
import shlex
import subprocess
import sys
import time

RESULT_PREFIX = "HARNESS_RESULT "


# ---------------------------------------------------------------------------
# Tiny JSON parser
# Python 2.4 predates the stdlib json module.  This implements exactly the
# normal JSON types needed by the dataset: objects, arrays, strings, numbers,
# true, false and null.
# ---------------------------------------------------------------------------

class JSONError(Exception):
    pass


class JSONParser(object):
    def __init__(self, text):
        self.text = text
        self.n = len(text)
        self.i = 0

    def parse(self):
        self._ws()
        value = self._value()
        self._ws()
        if self.i != self.n:
            self._error("extra data")
        return value

    def _error(self, message):
        raise JSONError("%s at character %d" % (message, self.i + 1))

    def _ws(self):
        while self.i < self.n and self.text[self.i] in " \t\r\n":
            self.i += 1

    def _value(self):
        self._ws()
        if self.i >= self.n:
            self._error("unexpected end of input")
        c = self.text[self.i]
        if c == '{':
            return self._object()
        if c == '[':
            return self._array()
        if c == '"':
            return self._string()
        if c == '-' or ('0' <= c <= '9'):
            return self._number()
        if self.text.startswith("true", self.i):
            self.i += 4
            return True
        if self.text.startswith("false", self.i):
            self.i += 5
            return False
        if self.text.startswith("null", self.i):
            self.i += 4
            return None
        self._error("unexpected character %r" % c)

    def _object(self):
        obj = {}
        self.i += 1
        self._ws()
        if self.i < self.n and self.text[self.i] == '}':
            self.i += 1
            return obj
        while 1:
            self._ws()
            if self.i >= self.n or self.text[self.i] != '"':
                self._error("object key must be a string")
            key = self._string()
            self._ws()
            if self.i >= self.n or self.text[self.i] != ':':
                self._error("expected ':'")
            self.i += 1
            value = self._value()
            obj[key] = value
            self._ws()
            if self.i >= self.n:
                self._error("unterminated object")
            if self.text[self.i] == '}':
                self.i += 1
                return obj
            if self.text[self.i] != ',':
                self._error("expected ',' or '}'")
            self.i += 1

    def _array(self):
        arr = []
        self.i += 1
        self._ws()
        if self.i < self.n and self.text[self.i] == ']':
            self.i += 1
            return arr
        while 1:
            arr.append(self._value())
            self._ws()
            if self.i >= self.n:
                self._error("unterminated array")
            if self.text[self.i] == ']':
                self.i += 1
                return arr
            if self.text[self.i] != ',':
                self._error("expected ',' or ']'")
            self.i += 1

    def _string(self):
        self.i += 1
        chars = []
        while self.i < self.n:
            c = self.text[self.i]
            self.i += 1
            if c == '"':
                return ''.join(chars)
            if c != '\\':
                chars.append(c)
                continue
            if self.i >= self.n:
                self._error("unterminated escape")
            e = self.text[self.i]
            self.i += 1
            escapes = {
                '"': '"', '\\': '\\', '/': '/', 'b': '\b', 'f': '\f',
                'n': '\n', 'r': '\r', 't': '\t'
            }
            if e in escapes:
                chars.append(escapes[e])
            elif e == 'u':
                if self.i + 4 > self.n:
                    self._error("short unicode escape")
                raw = self.text[self.i:self.i + 4]
                self.i += 4
                try:
                    code = int(raw, 16)
                except ValueError:
                    self._error("invalid unicode escape")
                # Dataset identifiers/paths are ASCII. Preserve ASCII directly;
                # encode other BMP characters as UTF-8 for completeness.
                if code < 128:
                    chars.append(chr(code))
                else:
                    chars.append(unichr(code).encode('utf-8'))
            else:
                self._error("invalid escape")
        self._error("unterminated string")

    def _number(self):
        start = self.i
        if self.text[self.i] == '-':
            self.i += 1
        if self.i >= self.n:
            self._error("bad number")
        if self.text[self.i] == '0':
            self.i += 1
        else:
            if not ('1' <= self.text[self.i] <= '9'):
                self._error("bad number")
            while self.i < self.n and self.text[self.i].isdigit():
                self.i += 1
        is_float = False
        if self.i < self.n and self.text[self.i] == '.':
            is_float = True
            self.i += 1
            if self.i >= self.n or not self.text[self.i].isdigit():
                self._error("bad fraction")
            while self.i < self.n and self.text[self.i].isdigit():
                self.i += 1
        if self.i < self.n and self.text[self.i] in 'eE':
            is_float = True
            self.i += 1
            if self.i < self.n and self.text[self.i] in '+-':
                self.i += 1
            if self.i >= self.n or not self.text[self.i].isdigit():
                self._error("bad exponent")
            while self.i < self.n and self.text[self.i].isdigit():
                self.i += 1
        raw = self.text[start:self.i]
        try:
            if is_float:
                return float(raw)
            return int(raw)
        except ValueError:
            try:
                return long(raw)
            except ValueError:
                self._error("bad number")


def json_loads(text):
    return JSONParser(text).parse()


# ---------------------------------------------------------------------------
# Dataset parsing / validation
# ---------------------------------------------------------------------------

def read_jsonl(path):
    records = []
    fh = open(path, 'rb')
    try:
        line_number = 0
        for raw in fh:
            line_number += 1
            line = raw.strip()
            if not line:
                continue
            try:
                value = json_loads(line)
            except JSONError, exc:
                raise ValueError("%s:%d: invalid JSON: %s" % (path, line_number, exc))
            if not isinstance(value, dict):
                raise ValueError("%s:%d: expected a JSON object" % (path, line_number))
            records.append(value)
    finally:
        fh.close()
    return records


def index_unique(records, key, path):
    result = {}
    for record in records:
        if key not in record:
            raise ValueError("%s: record is missing required key %r: %r" % (path, key, record))
        value = record[key]
        if not isinstance(value, basestring):
            raise ValueError("%s: %r must be a string: %r" % (path, key, record))
        if value in result:
            raise ValueError("%s: duplicate %s %r" % (path, key, value))
        result[value] = record
    return result


def read_file(path):
    fh = open(path, 'rb')
    try:
        return fh.read()
    finally:
        fh.close()


def write_file(path, text):
    fh = open(path, 'wb')
    try:
        fh.write(text)
    finally:
        fh.close()


def mkdir_p(path):
    if not os.path.isdir(path):
        os.makedirs(path)


def magma_string(value):
    return '"' + value.replace('\\', '\\\\').replace('"', '\\"') + '"'


def magma_literal(value):
    if value is True:
        return "true"
    if value is False:
        return "false"
    if isinstance(value, (int, long)):
        return str(value)
    if isinstance(value, float):
        return repr(value)
    if isinstance(value, basestring):
        return magma_string(value)
    if isinstance(value, list):
        return "[" + ",".join([magma_literal(item) for item in value]) + "]"
    if value is None:
        raise TypeError("null instance values are not supported as Magma arguments")
    raise TypeError("unsupported instance value for Magma: %r" % (value,))


def implementation_signature(root, source_id, implementation_path):
    path = os.path.join(root, implementation_path)
    text = read_file(path)
    function_name = source_id + "Implementation"
    pattern = re.compile(r"\b%s\s*:=\s*function\s*\(([^)]*)\)" % re.escape(function_name),
                         re.IGNORECASE | re.MULTILINE)
    match = pattern.search(text)
    if not match:
        raise ValueError("%s: cannot find %s:=function(...)" % (path, function_name))
    raw_parameters = match.group(1).strip()
    if raw_parameters:
        parameters = [p.strip() for p in raw_parameters.split(',')]
    else:
        parameters = []
    for p in parameters:
        if not p:
            raise ValueError("%s: malformed parameter list for %s" % (path, function_name))
    return function_name, parameters


def safe_slug(text):
    return re.sub(r"[^A-Za-z0-9_.-]+", "_", text)


class TestCase(object):
    pass


def build_script(case):
    arguments = [magma_literal(case.instance[name]) for name in case.parameters]
    call = "%s(%s)" % (case.function_name, ','.join(arguments))
    return '''/* Auto-generated model regression test.
   model #%d: plane=%s, source=%s
*/
load %s;
load "library/reference-model.m";

print "HARNESS_BEGIN plane=%s source=%s";
candidatePlane := %s;

if Type(candidatePlane) eq RngIntElt then
    print "%sCONSTRUCTION_FAILED";
else
    referencePlane, referencePoints, referenceLines := loadPackedProjectivePlane(%s);
    if IsIsomorphic(candidatePlane, referencePlane) then
        print "%sPASS";
    else
        print "%sFAIL";
    end if;
end if;
''' % (case.number, case.plane_id, case.source_id,
       magma_string(case.implementation_path),
       case.plane_id, case.source_id, call,
       RESULT_PREFIX, magma_string(case.plane_id),
       RESULT_PREFIX, RESULT_PREFIX)


def prepare_cases(root, generated_dir):
    planes_path = os.path.join(root, "planes.jsonl")
    sources_path = os.path.join(root, "sources.jsonl")
    models_path = os.path.join(root, "models.jsonl")

    planes = index_unique(read_jsonl(planes_path), "id", planes_path)
    sources = index_unique(read_jsonl(sources_path), "id", sources_path)
    models = read_jsonl(models_path)

    mkdir_p(generated_dir)
    signature_cache = {}
    cases = []

    number = 0
    for model in models:
        number += 1
        if "plane" not in model or "source" not in model or "instance" not in model:
            raise ValueError("%s: model #%d is missing plane/source/instance" % (models_path, number))
        plane_id = model["plane"]
        source_id = model["source"]
        instance = model["instance"]

        if not isinstance(plane_id, basestring) or plane_id not in planes:
            raise ValueError("%s: model #%d references unknown plane %r" % (models_path, number, plane_id))
        if not isinstance(source_id, basestring) or source_id not in sources:
            raise ValueError("%s: model #%d references unknown source %r" % (models_path, number, source_id))
        if not isinstance(instance, dict):
            raise ValueError("%s: model #%d instance must be an object" % (models_path, number))

        source = sources[source_id]
        implementation_path = source.get("implementation")
        if not isinstance(implementation_path, basestring):
            raise ValueError("%s: source %r has no implementation path" % (sources_path, source_id))
        if not os.path.isfile(os.path.join(root, implementation_path)):
            raise ValueError("%s: implementation does not exist: %s" % (sources_path, implementation_path))

        if source_id not in signature_cache:
            signature_cache[source_id] = implementation_signature(root, source_id, implementation_path)
        function_name, parameters = signature_cache[source_id]

        missing = [name for name in parameters if name not in instance]
        extra = [name for name in instance.keys() if name not in parameters]
        if missing or extra:
            pieces = []
            if missing:
                pieces.append("missing " + ", ".join(missing))
            if extra:
                pieces.append("extra " + ", ".join(extra))
            raise ValueError("%s: model #%d (%s/%s) instance/signature mismatch: %s" %
                             (models_path, number, plane_id, source_id, "; ".join(pieces)))

        reference_model = planes[plane_id].get("referenceModel")
        if (not isinstance(reference_model, basestring) or
                not os.path.isfile(os.path.join(root, reference_model))):
            raise ValueError("%s: plane %r has missing reference model %r" %
                             (planes_path, plane_id, reference_model))

        script_name = "%04d-%s-%s.m" % (number, safe_slug(plane_id), safe_slug(source_id))
        case = TestCase()
        case.number = number
        case.plane_id = plane_id
        case.source_id = source_id
        case.instance = instance
        case.implementation_path = implementation_path
        case.function_name = function_name
        case.parameters = parameters
        case.script_path = os.path.join(generated_dir, script_name)
        write_file(case.script_path, build_script(case))
        cases.append(case)

    return cases, planes, sources


# ---------------------------------------------------------------------------
# Magma execution
# ---------------------------------------------------------------------------

def run_case(root, case, magma_command):
    script = read_file(case.script_path)
    start = time.time()
    try:
        proc = subprocess.Popen(magma_command,
                                stdin=subprocess.PIPE,
                                stdout=subprocess.PIPE,
                                stderr=subprocess.STDOUT,
                                cwd=root)
        output = proc.communicate(script)[0]
        returncode = proc.returncode
    except OSError, exc:
        return "HARNESS_ERROR", str(exc), time.time() - start, None

    elapsed = time.time() - start
    status = "NO_RESULT"
    for line in output.splitlines():
        if line.startswith(RESULT_PREFIX):
            status = line[len(RESULT_PREFIX):].strip()
    if status == "NO_RESULT" and returncode != 0:
        status = "MAGMA_ERROR"
    return status, output, elapsed, returncode


def output_tail(output, line_count):
    parts = output.rstrip().splitlines()
    return "\n".join(parts[-line_count:])


def shell_quote(text):
    # Only for display; execution uses argv and does not invoke a shell.
    if re.match(r'^[A-Za-z0-9_./:=+-]+$', text):
        return text
    return "'" + text.replace("'", "'\\''") + "'"


USAGE = """Usage: python test_models_py2.py [options]

Options:
  --root DIR             dataset root (default: current directory)
  --magma COMMAND        Magma command/executable (default: magma)
  --generated-dir DIR    generated .m directory
  --generate-only        generate scripts but do not run Magma
  --fail-fast            stop after first non-PASS result
  --plane ID             test only this plane ID (repeatable)
  --source ID            test only this source ID (repeatable)
  --show-passing-output  show output for passing tests too
  -h, --help             show this help

Deliberately omitted in the Python 2.4 version: per-test timeout.  Python 2.4's
subprocess module has no timeout support, and adding a signal/process-group
implementation is probably not worth the complexity unless a Magma test hangs.
"""


def main(argv):
    root = os.getcwd()
    magma = "magma"
    generated_dir = None
    generate_only = False
    fail_fast = False
    wanted_planes = []
    wanted_sources = []
    show_passing_output = False

    try:
        opts, args = getopt.getopt(argv, "h", ["help", "root=", "magma=", "generated-dir=",
                                              "generate-only", "fail-fast", "plane=", "source=",
                                              "show-passing-output"])
    except getopt.GetoptError, exc:
        sys.stderr.write(str(exc) + "\n")
        sys.stderr.write(USAGE)
        return 2

    if args:
        sys.stderr.write("Unexpected positional arguments: %s\n" % " ".join(args))
        return 2

    for opt, value in opts:
        if opt in ("-h", "--help"):
            sys.stdout.write(USAGE)
            return 0
        elif opt == "--root":
            root = value
        elif opt == "--magma":
            magma = value
        elif opt == "--generated-dir":
            generated_dir = value
        elif opt == "--generate-only":
            generate_only = True
        elif opt == "--fail-fast":
            fail_fast = True
        elif opt == "--plane":
            wanted_planes.append(value)
        elif opt == "--source":
            wanted_sources.append(value)
        elif opt == "--show-passing-output":
            show_passing_output = True

    root = os.path.abspath(root)
    if generated_dir is None:
        generated_dir = os.path.join(root, ".test-harness", "generated")
    else:
        generated_dir = os.path.abspath(generated_dir)

    try:
        cases, planes, sources = prepare_cases(root, generated_dir)
    except (IOError, OSError, ValueError, TypeError), exc:
        sys.stderr.write("Harness setup failed: %s\n" % exc)
        return 2

    if wanted_planes:
        unknown = [x for x in wanted_planes if x not in planes]
        if unknown:
            sys.stderr.write("Unknown --plane value(s): %s\n" % ", ".join(unknown))
            return 2
        cases = [case for case in cases if case.plane_id in wanted_planes]

    if wanted_sources:
        unknown = [x for x in wanted_sources if x not in sources]
        if unknown:
            sys.stderr.write("Unknown --source value(s): %s\n" % ", ".join(unknown))
            return 2
        cases = [case for case in cases if case.source_id in wanted_sources]

    print "Loaded %d planes, %d sources, %d selected model tests." % (len(planes), len(sources), len(cases))
    print "Generated Magma scripts: %s" % generated_dir

    if generate_only:
        return 0

    magma_command = shlex.split(magma)
    if not magma_command:
        sys.stderr.write("--magma produced an empty command\n")
        return 2
    if "-b" not in magma_command:
        magma_command.append("-b")

    print "Magma command: %s" % " ".join([shell_quote(part) for part in magma_command])
    print

    counts = {}
    failed = False
    total = len(cases)

    ordinal = 0
    for case in cases:
        ordinal += 1
        label = "[%03d/%03d] %s <- %s" % (ordinal, total, case.plane_id, case.source_id)
        status, output, elapsed, returncode = run_case(root, case, magma_command)
        counts[status] = counts.get(status, 0) + 1
        print "%s: %s (%.2fs)" % (label, status, elapsed)

        if status != "PASS" or show_passing_output:
            tail = output_tail(output, 20)
            if tail:
                print "--- Magma output ---"
                print tail
                print "--------------------"
            if returncode not in (None, 0):
                print "Magma exit code: %s" % returncode

        if status != "PASS":
            failed = True
            if fail_fast:
                break

    print
    print "Summary:"
    statuses = counts.keys()
    statuses.sort()
    for status in statuses:
        print "  %-20s %d" % (status, counts[status])

    if failed:
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
