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

# aws ses set-identity-mail-from-domain --identity turai.work --mail-from-domain bounce.turai.work --region=ap-northeast-1


