#!/usr/bin/env cwl-runner
"@context": "https://raw.githubusercontent.com/common-workflow-language/common-workflow-language/master/schemas/draft-2/cwl-context.json"
class: Workflow
inputs:
    - id: "#file1"
      type: File
    - id: "#file2"
      type: File
outputs:
    - id: "#count_output"
      type: int
      connect: {"source": "#step2_output"}
steps:
  - id: "#step1"
    impl: count-lines4-wf.cwl
    inputs:
      - def: "count-lines4-wf.cwl#file1"
        connect: {"source": "#file1"}
      - def: "count-lines4-wf.cwl#file2"
        connect: {"source": "#file2"}
    outputs:
      - def: "count-lines4-wf.cwl#count_output"
        id: "#step1_output"
  - id: "#step2"
    class: ExpressionTool
    inputs:
      - id: "#a"
        type:
          type: array
          items: int
        connect: {source: "#step1_output"}
    outputs:
      - id: "#step2_output"
        type: int
    script:
      class: JavascriptExpression
      value: "{return {'step2_output': ($job.a[0] + $job.a[1])}; }"
