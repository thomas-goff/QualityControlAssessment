<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="QualityControlAssessment._Default" %>
<%@ Register Src="~/CaptureModal.ascx" TagPrefix="uc" TagName="CaptureModal" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Quality Control Measurements</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" />
</head>
<body class="bg-light">
    <form id="form1" runat="server">
        <nav class="navbar navbar-expand bg-white border-bottom mb-4">
            <div class="container-fluid">
                <span class="navbar-brand mb-0">Inambu Quality Control</span>
                <div class="d-flex align-items-center gap-3">
                    <span class="text-muted small">
                        Signed in as <asp:Label ID="UserNameLabel" runat="server" />
                    </span>
                    <asp:LinkButton ID="SignOutLinkButton" runat="server" CssClass="btn btn-sm btn-outline-secondary"
                        CausesValidation="false" OnClick="SignOutLinkButton_Click" Text="Sign Out" />
                </div>
            </div>
        </nav>

        <div class="container-fluid pb-5">

            <%--Add new measurement button--%> 
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="mb-0">Measurements</h5>
                <asp:Button ID="NewMeasurementButton" runat="server" CssClass="btn btn-primary"
                    Text="New Measurement" CausesValidation="false" OnClick="NewMeasurementButton_Click" />
            </div>

            <%--Calculated fields--%>
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-white fw-semibold">Calculated Fields</div>
                <div class="card-body p-0">
                    <asp:GridView ID="StatisticsGridView" runat="server"
                        AutoGenerateColumns="False"
                        CssClass="table table-sm table-striped mb-0"
                        GridLines="None"
                        EmptyDataText="No measurements captured yet.">
                        <Columns>
                            <asp:BoundField DataField="MetricName" HeaderText="Metric" />
                            <asp:BoundField DataField="MinValue" HeaderText="Lowest" DataFormatString="{0:N3}" />
                            <asp:BoundField DataField="MaxValue" HeaderText="Highest" DataFormatString="{0:N3}" />
                            <asp:BoundField DataField="SumValue" HeaderText="Sum" DataFormatString="{0:N3}" />
                            <asp:BoundField DataField="MeanValue" HeaderText="Mean" DataFormatString="{0:N3}" />
                            <asp:BoundField DataField="VarianceValue" HeaderText="Variance" DataFormatString="{0:N3}" />
                            <asp:BoundField DataField="StdDevValue" HeaderText="Std Dev" DataFormatString="{0:N3}" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

            <%--All record grid--%>
            <div class="card shadow-sm">
                <div class="card-header bg-white fw-semibold">All Records</div>
                <div class="card-body p-0">
                    <asp:GridView ID="MeasurementsGridView" runat="server"
                        AutoGenerateColumns="False"
                        DataKeyNames="QualityMeasurementId"
                        CssClass="table table-sm table-striped mb-0"
                        GridLines="None"
                        EmptyDataText="No measurements captured yet."
                        OnRowCommand="MeasurementsGridView_RowCommand"
                        OnRowDataBound="MeasurementsGridView_RowDataBound">
                        <Columns>
                            <asp:BoundField DataField="ProductionLineName" HeaderText="Production Line" />
                            <asp:BoundField DataField="Temperature" HeaderText="Temp" DataFormatString="{0:N2}" />
                            <asp:BoundField DataField="Humidity" HeaderText="Humidity" DataFormatString="{0:N2}" />
                            <asp:BoundField DataField="Weight" HeaderText="Weight" DataFormatString="{0:N3}" />
                            <asp:BoundField DataField="Width" HeaderText="Width" DataFormatString="{0:N3}" />
                            <asp:BoundField DataField="Length" HeaderText="Length" DataFormatString="{0:N3}" />
                            <asp:BoundField DataField="Depth" HeaderText="Depth" DataFormatString="{0:N3}" />
                            <asp:TemplateField HeaderText="Result">
                                <ItemTemplate>
                                    <span class='<%# (bool)Eval("Passed") ? "badge bg-success" : "badge bg-danger" %>'>
                                        <%# (bool)Eval("Passed") ? "Pass" : "Fail" %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Captured">
                                <ItemTemplate>
                                    <div><%# ToSouthAfricanTime(Eval("CapturedAtUtc")) %> <span class="text-muted small">SAST</span></div>
                                    <div class="text-muted small"><%# Eval("CapturedAtUtc", "{0:yyyy/MM/dd HH:mm}") %> UTC</div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="UserName" HeaderText="Captured By" />
                            <asp:TemplateField HeaderText="">
                                <ItemTemplate>
                                    <asp:LinkButton ID="EditButton" runat="server"
                                        CssClass="btn btn-sm btn-outline-primary"
                                        CommandName="EditMeasurement"
                                        CommandArgument='<%# Eval("QualityMeasurementId") %>'
                                        CausesValidation="false" Text="Edit" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="">
                                <ItemTemplate>
                                    <asp:LinkButton ID="DeleteButton" runat="server"
                                        CssClass="btn btn-sm btn-outline-danger"
                                        CommandName="DeleteMeasurement"
                                        CommandArgument='<%# Eval("QualityMeasurementId") %>'
                                        CausesValidation="false" Text="Delete"
                                        OnClientClick="return confirm('Delete this measurement? This cannot be undone.');" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <uc:CaptureModal ID="CaptureModal1" runat="server" OnMeasurementSaved="CaptureModal1_MeasurementSaved" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </form>
</body>
</html>
