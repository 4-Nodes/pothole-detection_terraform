resource "aws_secretsmanager_secret" "ghcr_token" {
  name = "pothole-detection-ghcr-token"
}

resource "aws_secretsmanager_secret_version" "ghcr_token_version" {
  secret_id     = aws_secretsmanager_secret.ghcr_token.id
  secret_string = var.ghcr_token
}
