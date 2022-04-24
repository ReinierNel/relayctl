resource "restapi_object" "relay_gpio_17" {
  path = "/relays/add"
  data = jsonencode({
      gpio = 17
  })
}

resource "restapi_object" "relay_gpio_18" {
  path = "/relays/add"
  data = jsonencode({
      gpio = 18
  })
}

resource "restapi_object" "relay_gpio_27" {
  path = "/relays/add"
  data = jsonencode({
      gpio = 27
  })
}

resource "restapi_object" "relay_gpio_22" {
  path = "/relays/add"
  data = jsonencode({
      gpio = 22
  })
}

resource "restapi_object" "switch_gpio_16" {
  path = "/switches/add"
  data = jsonencode({
    gpio = 16,
    relay_id = 1,
    action = 1
  })
}

resource "restapi_object" "schedule_17_00_on" {
  path = "/schedules/add"
  data = jsonencode({
    relay_id = 2,
    action = 1,
    start = "17:00",
    end = "17:59"
  })
}

resource "restapi_object" "schedule_18_00_off" {
  path = "/schedules/add"
  data = jsonencode({
    relay_id = 2,
    action = 0,
    start = "18:00",
    end = "18:59"
  })
}