#!/usr/bin/env cwl-runner
"@context": "https://raw.githubusercontent.com/common-workflow-language/common-workflow-language/master/schemas/draft-2/cwl-context.json"
class: Workflow
inputs:
    - id: "#file1"
      type: File
outputs:
    - id: "#count_output"
      type: int
      connect: {"source": "#step2_output"}
steps:
    - id: "#step1"
      class: CommandLineTool
      inputs:
        - id: "#step1_file1"
          type: File
          commandLineBinding: {}
          connect: {"source": "#file1"}
      outputs:
        - id: "#step1_output"
          type: File
          outputBinding:
            glob: output.txt
      stdout: output.txt
      baseCommand: ["wc"]
    - id: "#step2"
      class: ExpressionTool
      inputs:
        - id: "#step2_file1"
          type: File
          loadContents: true
          connect: {"source": "#step1_output"}
      outputs:
        - id: "#step2_output"
          type: int
      script:
        class: JavascriptExpression
        value: "{return {'step2_output': parseInt($job.step2_file1.contents)};}"
