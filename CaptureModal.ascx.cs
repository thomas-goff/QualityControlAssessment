using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;

namespace QualityControlAssessment
{
    public partial class CaptureModal : UserControl
    {
        private static readonly string ConnectionString =
            ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        public event EventHandler MeasurementSaved;

        private int CurrentUserId
        {
            get { return int.Parse(Context.User.Identity.Name, CultureInfo.InvariantCulture); }
        }

        private int? EditingMeasurementId
        {
            get { return ViewState["EditingMeasurementId"] as int?; }
            set { ViewState["EditingMeasurementId"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
                return;

            BindProductionLines();
        }

        private void BindProductionLines()
        {
            using (var connection = new SqlConnection(ConnectionString))
            using (var command = new SqlCommand("dbo.GetAllProductionLines", connection))
            {
                command.CommandType = CommandType.StoredProcedure;

                var table = new DataTable();
                using (var adapter = new SqlDataAdapter(command))
                {
                    adapter.Fill(table);
                }

                ProductionLineDropDownList.DataSource = table;
                ProductionLineDropDownList.DataBind();
            }
        }

        public void ShowForAdd()
        {
            EditingMeasurementId = null;
            ModalTitleLabel.Text = "New Measurement";

            ClearModalInputs();
            OpenModal();
        }

        public void ShowForEdit(int measurementId, int productionLineId,
            decimal temperature, decimal humidity, decimal weight,
            decimal width, decimal length, decimal depth, bool passed)
        {
            EditingMeasurementId = measurementId;
            ModalTitleLabel.Text = "Edit Measurement";

            ModalErrorLabel.Visible = false;

            ProductionLineDropDownList.SelectedValue = productionLineId.ToString(CultureInfo.InvariantCulture);
            TemperatureTextBox.Text = temperature.ToString(CultureInfo.InvariantCulture);
            HumidityTextBox.Text = humidity.ToString(CultureInfo.InvariantCulture);
            WeightTextBox.Text = weight.ToString(CultureInfo.InvariantCulture);
            WidthTextBox.Text = width.ToString(CultureInfo.InvariantCulture);
            LengthTextBox.Text = length.ToString(CultureInfo.InvariantCulture);
            DepthTextBox.Text = depth.ToString(CultureInfo.InvariantCulture);
            PassedRadioButtonList.SelectedValue = passed ? "1" : "0";

            OpenModal();
        }

        protected void SaveMeasurementButton_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                OpenModal();
                return;
            }

            try
            {
                if (EditingMeasurementId.HasValue)
                {
                    int rowsAffected = UpdateMeasurement(EditingMeasurementId.Value);

                    // User owned update meaning that if no rows are returned either SQL error or 
                    // they are trying to update a row that isnt theirs 
                    if (rowsAffected == 0)
                    {
                        ShowModalError("You can only update your own measurements.");
                        OpenModal();
                        return;
                    }
                }
                else
                {
                    InsertMeasurement();
                }
            }
            catch (SqlException)
            {
                ShowModalError("The measurement could not be saved. Please check the values and try again.");
                OpenModal();
                return;
            }

            ClearModalInputs();
            EditingMeasurementId = null;

            // Tell default.aspx that a save has occured to update the grid 
            if (MeasurementSaved != null)
            {
                MeasurementSaved(this, EventArgs.Empty);
            }
        }

        private void InsertMeasurement()
        {
            using (var connection = new SqlConnection(ConnectionString))
            using (var command = new SqlCommand("dbo.InsertMeasurement", connection))
            {
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.Add("@ProductionLineId", SqlDbType.Int).Value =
                    int.Parse(ProductionLineDropDownList.SelectedValue, CultureInfo.InvariantCulture);

                command.Parameters.Add("@UserId", SqlDbType.Int).Value = CurrentUserId;

                AddMeasurementValues(command);

                connection.Open();
                command.ExecuteNonQuery();
            }
        }

        private int UpdateMeasurement(int measurementId)
        {
            using (var connection = new SqlConnection(ConnectionString))
            using (var command = new SqlCommand("dbo.UpdateMeasurement", connection))
            {
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.Add("@QualityMeasurementId", SqlDbType.Int).Value = measurementId;
                command.Parameters.Add("@UserId", SqlDbType.Int).Value = CurrentUserId;

                command.Parameters.Add("@ProductionLineId", SqlDbType.Int).Value =
                    int.Parse(ProductionLineDropDownList.SelectedValue, CultureInfo.InvariantCulture);

                AddMeasurementValues(command);

                connection.Open();

                return Convert.ToInt32(command.ExecuteScalar());
            }
        }

        //Add the values shared by both insert and update procs
        private void AddMeasurementValues(SqlCommand command)
        {
            AddDecimal(command, "@Temperature", TemperatureTextBox.Text);
            AddDecimal(command, "@Humidity", HumidityTextBox.Text);
            AddDecimal(command, "@Weight", WeightTextBox.Text);
            AddDecimal(command, "@Width", WidthTextBox.Text);
            AddDecimal(command, "@Length", LengthTextBox.Text);
            AddDecimal(command, "@Depth", DepthTextBox.Text);

            command.Parameters.Add("@Passed", SqlDbType.Bit).Value =
                PassedRadioButtonList.SelectedValue == "1";
        }

        private static void AddDecimal(SqlCommand command, string name, string text)
        {
            var parameter = command.Parameters.Add(name, SqlDbType.Decimal);
            parameter.Value = decimal.Parse(text.Trim(), NumberStyles.Number, CultureInfo.InvariantCulture);
        }

        private void OpenModal()
        {
            Page.ClientScript.RegisterStartupScript(
                GetType(),
                "openNewMeasurementModal",
                "new bootstrap.Modal(document.getElementById('newMeasurementModal')).show();",
                true);
        }

        private void ShowModalError(string message)
        {
            ModalErrorLabel.Text = message;
            ModalErrorLabel.Visible = true;
        }

        private void ClearModalInputs()
        {
            ProductionLineDropDownList.SelectedValue = string.Empty;
            TemperatureTextBox.Text = string.Empty;
            HumidityTextBox.Text = string.Empty;
            WeightTextBox.Text = string.Empty;
            WidthTextBox.Text = string.Empty;
            LengthTextBox.Text = string.Empty;
            DepthTextBox.Text = string.Empty;
            PassedRadioButtonList.SelectedValue = "1";

            ModalErrorLabel.Visible = false;
        }
    }
}