using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Security;
using System.Configuration;

namespace QualityControlAssessment
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void LoginButton_Click(object sender, EventArgs e)
        {
            string email = EmailTextBox.Text.Trim();
            string password = PasswordTextBox.Text;

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                ShowError("Email and password are required.");
                return;
            }

            using (var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString))
            using (var command = new SqlCommand("dbo.GetUsersByEmail", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@Email", email);

                connection.Open();

                using (var reader = command.ExecuteReader(CommandBehavior.SingleRow))
                {
                    if (!reader.Read())
                    {
                        ShowError("Invalid email or password.");
                        return;
                    }

                    int userId = (int)reader["UserId"];
                    string userName = (string)reader["UserName"];
                    byte[] storedHash = (byte[])reader["PasswordHash"];
                    byte[] storedSalt = (byte[])reader["PasswordSalt"];

                    if (!PasswordHasher.Verify(password, storedHash, storedSalt))
                    {
                        ShowError("Invalid email or password.");
                        return;
                    }

                    // Put the display name in the auth ticket so it lasts as
                    // long as the login does, even across app restarts.
                    var ticket = new FormsAuthenticationTicket(
                        1,
                        userId.ToString(),
                        DateTime.Now,
                        DateTime.Now.Add(FormsAuthentication.Timeout),
                        false,
                        userName);

                    string encryptedTicket = FormsAuthentication.Encrypt(ticket);
                    var authCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket);
                    Response.Cookies.Add(authCookie);

                    Response.Redirect(FormsAuthentication.GetRedirectUrl(userId.ToString(), false));
                }
            }
        }

        private void ShowError(string message)
        {
            LoginErrorLabel.Text = message;
            LoginErrorLabel.Visible = true;
        }
    }
}