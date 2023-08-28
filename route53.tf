 #create hosted zone
 resource "aws_route53_zone" "hosted_zone" {
  name =   "${var.domain_name}"
}

#create a simple alias record
resource "aws_route53_record" "simple_record" {
  zone_id = "${aws_route53_zone.hosted_zone.zone_id}"
  name    = "${var.domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_lb.application_load_balancer.dns_name}"
    zone_id                = "${aws_lb.application_load_balancer.zone_id}"
    evaluate_target_health = true
  }
}

#create a simple record for our sub domain
resource "aws_route53_record" "www-a" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_lb.application_load_balancer.dns_name}"
    zone_id                = "${aws_lb.application_load_balancer.zone_id}"
    evaluate_target_health = false
  }
}



resource "aws_route53_record" "cert_validation" {
 for_each = {
   for dvo in aws_acm_certificate.acm_cert.domain_validation_options : dvo.domain_name => {
     name    = dvo.resource_record_name
     record  = dvo.resource_record_value
     type    = dvo.resource_record_type
   }
 }

 allow_overwrite = true
 name            = each.value.name
 records         = [each.value.record]
 ttl             = 60
 type            = each.value.type
 zone_id         =  "${aws_route53_zone.hosted_zone.zone_id}"
}


