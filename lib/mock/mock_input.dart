final String jsonInput = """
 {
  "switch_details": [
    {
      "global_key": "sw_1",
      "output_map": {
        "global_key": "fr_1",
        "input_pin": 1
      }
    },
    {
      "global_key": "sw_2",
      "output_map": {
        "global_key": "fr_1",
        "input_pin": 2
      }
    },
    {
      "global_key": "sw_3",
      "output_map": {
        "global_key": "fr_2",
        "input_pin": 1
      }
    },
    {
      "global_key": "sw_4",
      "output_map": {
        "global_key": "fr_2",
        "input_pin": 2
      }
    },
    {
      "global_key": "sw_5",
      "output_map": {
        "global_key": "fr_3",
        "input_pin": 1
      }
    },
     {
      "global_key": "sw_6",
      "output_map": {
        "global_key": "fr_3",
        "input_pin": 2
      }
    }
  ],
  "logic_gate_details": [
    [
      {
        "global_key": "sr_2",
        "gate_type": 1,
        "output_map": []
      },
      {
        "global_key": "sr_1",
        "gate_type": 1,
        "output_map": []
      }
    ],
    [
      {
        "global_key": "fr_3",
        "gate_type": 1,
        "output_map": [
          {
            "global_key": "sr_2",
            "input_pin": 1
          }
        ]
      },
      {
        "global_key": "fr_2",
        "gate_type": 4,
        "output_map": [
          {
            "global_key": "sr_1",
            "input_pin": 1
          },
          {
            "global_key": "sr_2",
            "input_pin": 2
          }
        ]
      },
      {
        "global_key": "fr_1",
        "gate_type": 1,
        "output_map": [
          {
            "global_key": "sr_1",
            "input_pin": 2
          }
        ]
      }
    ]
  ]
}""";


