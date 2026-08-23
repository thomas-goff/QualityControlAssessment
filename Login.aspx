<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="QualityControlAssessment.Login" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Sign In</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="d-flex justify-content-center align-items-center vh-100">
            <div class="card shadow-sm" style="width: 360px;">
                <div class="card-body">
                    <h5 class="card-title mb-3">Sign In</h5>

                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <asp:TextBox ID="EmailTextBox" runat="server" CssClass="form-control" TextMode="Email" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <asp:TextBox ID="PasswordTextBox" runat="server" CssClass="form-control" TextMode="Password" />
                    </div>

                    <asp:Label ID="LoginErrorLabel" runat="server" CssClass="text-danger d-block mb-2" Visible="false" />

                    <asp:Button ID="LoginButton" runat="server" Text="Sign In" CssClass="btn btn-primary w-100"
                        OnClick="LoginButton_Click" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
