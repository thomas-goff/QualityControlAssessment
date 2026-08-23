using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QualityControlAssessment
{
    public partial class _Default : Page
    {
        private static readonly string ConnectionString =
            ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        private static readonly TimeZoneInfo SouthAfricanTimeZone =
            TimeZoneInfo.FindSystemTimeZoneById("South Africa Standard Time");

        private int CurrentUserId
        {
            get { return int.Parse(User.Identity.Name, CultureInfo.InvariantCulture); }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
                return;

            // The display name rides in the auth ticket's UserData.
            var identity = User.Identity as FormsIdentity;
            UserNameLabel.Text = identity != null ? identity.Ticket.UserData : string.Empty;

            BindStatistics();
            BindMeasurements();
        }

        protected void CaptureModal1_MeasurementSaved(object sender, EventArgs e)
        {
            BindStatistics();
            BindMeasurements();
        }

        protected void NewMeasurementButton_Click(object sender, EventArgs e)
        {
            CaptureModal1.ShowForAdd();
        }

        protected void MeasurementsGridView_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "EditMeasurement" && e.CommandName != "DeleteMeasurement")
                return;

            int measurementId = int.Parse((string)e.CommandArgument, CultureInfo.InvariantCulture);

            if (e.CommandName == "EditMeasurement")
            {
                EditMeasurement(measurementId);
            }
            else
            {
                DeleteMeasurement(measurementId);
            }
        }

        protected void EditMeasurement(int measurementId)
        {
            DataRow row = FindMeasurement(measurementId);
            if (row == null)
            {
                BindMeasurements();
                return;
            }

            CaptureModal1.ShowForEdit(
                measurementId,
                (int)row["ProductionLineId"],
                (decimal)row["Temperature"],
                (decimal)row["Humidity"],
                (decimal)row["Weight"],
                (decimal)row["Width"],
                (decimal)row["Length"],
                (decimal)row["Depth"],
                (bool)row["Passed"]);
        }

        private void DeleteMeasurement(int measurementId)
        {
            using (var connection = new SqlConnection(ConnectionString))
            using (var command = new SqlCommand("dbo.DeleteMeasurement", connection))
            {
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.Add("@QualityMeasurementId", SqlDbType.Int).Value = measurementId;
                command.Parameters.Add("@UserId", SqlDbType.Int).Value = CurrentUserId;

                connection.Open();
                command.ExecuteScalar();
            }

            BindStatistics();
            BindMeasurements();
        }

        protected void MeasurementsGridView_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow)
                return;

            int rowUserId = (int)DataBinder.Eval(e.Row.DataItem, "UserId");
            bool isOwner = rowUserId == CurrentUserId;

            var editButton = (WebControl)e.Row.FindControl("EditButton");
            if (editButton != null)
            {
                editButton.Visible = isOwner;
            }

            var deleteButton = (WebControl)e.Row.FindControl("DeleteButton");
            if (deleteButton != null)
            {
                deleteButton.Visible = isOwner;
            }
        }

        private DataRow FindMeasurement(int measurementId)
        {
            DataTable table = GetDataTable("dbo.GetAllMeasurements");
            DataRow[] matches = table.Select("QualityMeasurementId = " + measurementId);

            return matches.Length == 0 ? null : matches[0];
        }

        // Data binding
        private void BindStatistics()
        {
            StatisticsGridView.DataSource = GetDataTable("dbo.GetCalculatedMeasurements");
            StatisticsGridView.DataBind();
        }

        private void BindMeasurements()
        {
            MeasurementsGridView.DataSource = GetDataTable("dbo.GetAllMeasurements");
            MeasurementsGridView.DataBind();
        }

        private static DataTable GetDataTable(string storedProcedureName)
        {
            var table = new DataTable();

            using (var connection = new SqlConnection(ConnectionString))
            using (var command = new SqlCommand(storedProcedureName, connection))
            {
                command.CommandType = CommandType.StoredProcedure;

                using (var adapter = new SqlDataAdapter(command))
                {
                    adapter.Fill(table);
                }
            }

            return table;
        }

        protected string ToSouthAfricanTime(object capturedAtUtc)
        {
            if (capturedAtUtc == null || capturedAtUtc == DBNull.Value)
                return string.Empty;

            var utc = DateTime.SpecifyKind((DateTime)capturedAtUtc, DateTimeKind.Utc);
            var local = TimeZoneInfo.ConvertTimeFromUtc(utc, SouthAfricanTimeZone);

            return local.ToString("yyyy/MM/dd HH:mm", CultureInfo.InvariantCulture);
        }

        // Sign out
        protected void SignOutLinkButton_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            FormsAuthentication.SignOut();
            FormsAuthentication.RedirectToLoginPage();
        }
    }
}