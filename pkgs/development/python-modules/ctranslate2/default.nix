{
  lib,
  buildPythonPackage,

  # build-system
  pybind11,
  setuptools,

  # dependencies
  ctranslate2-cpp,
  numpy,
  pyyaml,

  # tests
  pytestCheckHook,
  torch,
  transformers,
  wurlitzer,
}:

buildPythonPackage rec {
  inherit (ctranslate2-cpp) pname version src;
  pyproject = true;

  # https://github.com/OpenNMT/CTranslate2/tree/master/python
  sourceRoot = "${src.name}/python";

  build-system = [
    pybind11
    setuptools
  ];

  buildInputs = [ ctranslate2-cpp ];

  dependencies = [
    numpy
    pyyaml
  ];

  pythonImportsCheck = [
    # https://opennmt.net/CTranslate2/python/overview.html
    "ctranslate2"
    "ctranslate2.converters"
    "ctranslate2.models"
    "ctranslate2.specs"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    torch
    transformers
    wurlitzer
  ];

  preCheck = ''
    # run tests against build result, not sources
    rm -rf ctranslate2

    export HOME=$TMPDIR
  '';

  disabledTestPaths = [
    # TODO: ModuleNotFoundError: No module named 'opennmt'
    "tests/test_opennmt_tf.py"
    # OSError: We couldn't connect to 'https://huggingface.co' to load this file
    "tests/test_transformers.py"
  ];

  meta = with lib; {
    description = "Fast inference engine for Transformer models";
    homepage = "https://github.com/OpenNMT/CTranslate2";
    changelog = "https://github.com/OpenNMT/CTranslate2/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
