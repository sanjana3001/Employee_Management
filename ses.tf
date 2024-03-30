############################ Source and destination Email for SES triggers ############################
resource "aws_ses_email_identity" "source_alert_email" {
  email = "sanjanas.3001+source@gmail.com"
}

resource "aws_ses_email_identity" "delivery_alert_email" {
  email = "sanjanas.3001@gmail.com"
}
