window.WeatherShared =
  getBackground: (temp) ->
    range =
      0: -10
      1: [-10..0]
      2: [1..32]
      3: [33..44]
      4: [45..54]
      5: [55..64]
      6: [65..74]
      7: [75..89]
      8: 90

    weather = "#4b4b4b"

    switch
      when temp <= range[0] then weather = 'cold5'
      when temp in range[1] then weather = 'cold4'
      when temp in range[2] then weather = 'cold3'
      when temp in range[3] then weather = 'cold2'
      when temp in range[4] then weather = 'cold1'
      when temp in range[5] then weather = 'cool2'
      when temp in range[6] then weather = 'cool1'
      when temp in range[7] then weather = 'warm'
      when temp >= range[8] then weather = 'hot'

    weather
