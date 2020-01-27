module "elb_web" {
  source = "terraform-flexibleengine-modules/elb/flexibleengine"
  version = "1.0.0"

  loadbalancer_name = "my-http-elb"

  subnet_id = "my-subnet-id"

  bind_eip = true

  cert = true

  domain = "my-domain-name.com"

  cert_name = "my-cert-name"

  certId = "my-cert-id"

  vip_address = "192.168.13.148"

  listeners = [
              {
              name = "http"
              port = 80
              protocol = "HTTP"
              hasCert = false
              },
              {
              name = "https"
              port = 443
              protocol = "TERMINATED_HTTPS"
              hasCert = true
              }
              ]

  pools = [   {
              name = "poolhttp"
              protocol = "HTTP"
              lb_method = "ROUND_ROBIN"
              listener_index = 0
              },
              {
              name = "poolhttps"
              protocol = "HTTP"
              lb_method = "ROUND_ROBIN"
              listener_index = 1
              }
            ]

  backends = [
            {
              name = "backend1"
              port = 80
              address_index = 0
              pool_index = 0
              subnet_id = "backend1-subnet-id"
            },
            {
              name = "backend2"
              port = 80
              address_index = 1
              pool_index = 0
              subnet_id = "backend1-subnet-id"
            },
            {
              name = "backend3"
              port = 443
              address_index = 0
              pool_index = 1
              subnet_id = "backend1-subnet-id"
            },
            {
              name = "backend4"
              port = 443
              address_index = 1
              pool_index = 1
              subnet_id = "backend1-subnet-id"
            }
            ]

   backends_addresses = ["192.168.13.102","192.168.13.247"]

  monitorsHttp =  [
            {
              name = "monitor1"
              pool_index = 0
              protocol = "HTTP"
              delay = 20
              timeout = 10
              max_retries = 3
              url_path = "/check"
              http_method = "GET"
              expected_codes = "2xx,3xx,4xx"
            },
            {
              name = "monitor2"
              pool_index = 1
              protocol = "HTTP"
              delay = 20
              timeout = 10
              max_retries = 3
              url_path = "/check"
              http_method = "GET"
              expected_codes = "2xx,3xx,4xx"
            }
            ]    

  listeners_whitelist = [
    {
      enable_whitelist = true
      whitelist = "192.168.11.1,192.168.0.1/24,192.168.201.18/8"
      listeners_index = 0
    }
  ]

}

