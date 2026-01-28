{...}: {
  services.hyprsunset = {
    enable = false;
    transitions = {
      sunrise = {
        calendar = "*-*-* 06:00:00";
        requests = [
          [
            "temperature"
            "6500"
          ]
          ["gamma 100"]
        ];
      };

      sunset = {
        calendar = "*-*-* 19:00:00";
        requests = [
          [
            "temperature"
            "5500"
          ]
        ];
      };
    };
  };
}
