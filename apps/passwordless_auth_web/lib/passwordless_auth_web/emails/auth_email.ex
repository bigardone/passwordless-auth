defmodule PasswordlessAuthWeb.Emails.AuthEmail do
  import Bamboo.Email, only: [new_email: 1]
  import PasswordlessAuthWeb.Router.Helpers

  @from "support@passwordlessauth.com"

  def build(email, token) do
    url = page_url(PasswordlessAuthWeb.Endpoint, :show, token)

    new_email(
      to: email,
      from: @from,
      subject: "Your authentication link",
      html_body: """
      <p>Here is your authentication link:</p>
      <a href="#{url}">#{url}</a>
      <p>It is valid for 5 minutes.</p>
      """,
      text_body: """
      Here is your authentication link: \n
      #{url}\n
      It is valid for 5 minutes.
      """
    )
  end
end
