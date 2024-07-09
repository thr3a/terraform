resource "aws_iam_user" "main" {
  name = "ses-smtp-turai-work"
}

resource "aws_iam_user_policy" "ses_smtp_policy" {
  name = "ses-smtp-policy"
  user = aws_iam_user.main.name
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_access_key" "ses_smtp_access_key" {
  user = aws_iam_user.main.name
}

# output "ses_smtp_access_key_id" {
#   value = aws_iam_access_key.ses_smtp_access_key.id
# }

# output "ses_smtp_secret_access_key" {
#   value     = aws_iam_access_key.ses_smtp_access_key.secret
#   sensitive = true
# }


# aws ses verify-email-identity --email-address thr3a@turai.work --region=ap-northeast-1


# aws ses set-identity-mail-from-domain --identity turai.work --mail-from-domain bounce.turai.work --region=ap-northeast-1


# bounce.turai.work	MX	10 feedback-smtp.ap-northeast-1.amazonses.com
# bounce.turai.work	TXT	"v=spf1 include:amazonses.com ~all"


# aws ses get-identity-mail-from-domain-attributes --identities turai.work --query 'MailFromDomainAttributes.*.MailFromDomainStatus'

# ❯ aws ses get-identity-mail-from-domain-attributes --identities turai.work --query 'MailFromDomainAttributes.*.MailFromDomainStatus' --region=ap-northeast-1
# [
#     "Success"
# ]
