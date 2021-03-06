module "elb_web" {
  source  = "terraform-flexibleengine-modules/elb/flexibleengine"
  version = "1.0.0"

  loadbalancer_name = "my-http-elb"

  subnet_id = "my-subnet-id"

  bind_eip = true

  eip_addr = "11.11.11.11"

  cert = true

  domain = "my-domain-name.com"

  cert_name = "my-cert-name"

  certId = "my-cert-id"

  vip_address = "192.168.13.148"

  listeners = [
    {
      name     = "https"
      port     = 443
      protocol = "TERMINATED_HTTPS"
      hasCert  = true
    }
  ]

  pools = [{
    name           = "poolhttps"
    protocol       = "HTTP"
    lb_method      = "ROUND_ROBIN"
    listener_index = 0
    },
    {
      name           = "poolhttps2"
      protocol       = "HTTP"
      lb_method      = "ROUND_ROBIN"
      listener_index = null
    }
  ]

  backends = [
    {
      name          = "backend1"
      port          = 80
      address_index = 0
      pool_index    = 0
      subnet_id     = "backend1-subnet-id"
    },
    {
      name          = "backend2"
      port          = 80
      address_index = 1
      pool_index    = 0
      subnet_id     = "backend2-subnet-id"
    },
    {
      name          = "backend3"
      port          = 80
      address_index = 0
      pool_index    = 1
      subnet_id     = "backend3-subnet-id"
    },
    {
      name          = "backend4"
      port          = 80
      address_index = 1
      pool_index    = 1
      subnet_id     = "backend4-subnet-id"
    }
  ]

  backends_addresses = ["192.168.13.102", "192.168.13.247"]

  monitorsHttp = [
    {
      name           = "monitor1"
      pool_index     = 0
      protocol       = "HTTP"
      delay          = 20
      timeout        = 10
      max_retries    = 3
      url_path       = "/check"
      http_method    = "GET"
      expected_codes = "2xx,3xx,4xx"
    },
    {
      name           = "monitor2"
      pool_index     = 1
      protocol       = "HTTP"
      delay          = 20
      timeout        = 10
      max_retries    = 3
      url_path       = "/check"
      http_method    = "GET"
      expected_codes = "2xx,3xx,4xx"
    }
  ]

  l7policies = [
    {
      name                    = "redirect_to_https"
      action                  = "REDIRECT_TO_POOL"
      description             = "l7 policy to request to another pool"
      position                = 1
      listener_index          = 0
      redirect_pool_index     = 1
      redirect_listener_index = null
    }
  ]

  l7policies_rules = [
    {
      type           = "PATH"
      compare_type   = "EQUAL_TO"
      value          = "/api"
      l7policy_index = 0
    }
  ]

}