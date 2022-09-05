resource "aws_route53_resolver_endpoint" "outbound_resolver" {
  name      = "${var.org}-${var.project}-${var.environment}-resolver"
  direction = "OUTBOUND"

  security_group_ids = [
    aws_security_group.shared_vpc.id
  ]

  ip_address {
  subnet_id = "${aws_subnet.workload_private.*.id[0]}"
  }

  ip_address {
  subnet_id = "${aws_subnet.workload_private.*.id[1]}"
  }

  ip_address {
  subnet_id = "${aws_subnet.workload_private.*.id[2]}"
  }
}

resource "aws_route53_resolver_rule" "fwd1" {
  domain_name          = var.route_domain1
  name                 = "lion_aws-forwarder-${var.environment}"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.outbound_resolver.id

  target_ip {
    ip = "10.155.10.5"
  }
  
  target_ip {
    ip = "10.155.11.5"
  }
}

resource "aws_route53_resolver_rule" "fwd2" {
  domain_name          = var.route_domain2
  name                 = "lncorp_net-forwarder-${var.environment}"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.outbound_resolver.id

  target_ip {
    ip = "10.155.10.5"
  }

  target_ip {
    ip = "10.155.11.5"
  }
}

resource "aws_route53_resolver_rule_association" "outbound_attach_lion" {
  resolver_rule_id = aws_route53_resolver_rule.fwd1.id
  vpc_id           = aws_vpc.main.id
}

resource "aws_route53_resolver_rule_association" "outbound_attach_lncorp" {
  resolver_rule_id = aws_route53_resolver_rule.fwd2.id
  vpc_id           = aws_vpc.main.id
}
