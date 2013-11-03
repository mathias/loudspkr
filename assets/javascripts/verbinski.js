console.log("Verbinski (the weather widget) has been loaded!");

function getIcon(iconKey) {
  var prefix = "/assets/climacons/svg/";
  var ext = ".svg";

  if (!iconKey) {
    return prefix + "Cloud-Refresh" + ext;
  }

  var key = iconKey.replace(/-/g, "_");
  var iconMap = {
    clear_day: "Sun",
    clear_night: "Moon",
    rain: "Cloud-Rain",
    snow: "Snowflake",
    sleet: "Cloud-Hail",
    wind: "Wind",
    fog: "Cloud-Fog-Alt",
    cloudy: "Cloud",
    partly_cloudy_day: "Cloud-Sun",
    partly_cloudy_night: "Cloud-Moon"
  }
  var fullPath = prefix + iconMap[key] + ext;
  return fullPath;
}

function getWindDirection(windBearing) {
  // windBearing is where the wind is coming FROM
  var direction;
  if ((windBearing > 315) || (windBearing < 45)) {
    direction = "S";
  } else if ((windBearing >= 45) && (windBearing < 135)) {
    direction = "W";
  } else if ((windBearing >= 135) && (windBearing < 225)) {
    direction = "N";
  } else {
    direction = "E";
  }
  return direction;
}
