data "aws_route53_zone" "this" {
  name = var.r53-zone
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "${var.env}.${var.animal}"
  type    = "A"
  records = [aws_instance.dpg-2048.public_ip]
  ttl     = 30
}
