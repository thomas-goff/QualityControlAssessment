<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CaptureModal.ascx.cs" Inherits="QualityControlAssessment.CaptureModal" %>

<%--Measurement modal--%>
<div class="modal fade" id="newMeasurementModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><asp:Label ID="ModalTitleLabel" runat="server" Text="New Measurement" /></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <asp:ValidationSummary ID="NewMeasurementValidationSummary" runat="server"
                    ValidationGroup="NewMeasurement" CssClass="alert alert-danger" DisplayMode="List" />
                <asp:Label ID="ModalErrorLabel" runat="server" CssClass="alert alert-danger d-block" Visible="false" />
                <div class="row align-items-center mb-3">
                    <label class="col-md-3 col-form-label">Production Line</label>
                    <div class="col-md-9">
                        <asp:DropDownList ID="ProductionLineDropDownList" runat="server"
                            CssClass="form-select" AppendDataBoundItems="true"
                            DataTextField="ProductionLineName" DataValueField="ProductionLineId">
                            <asp:ListItem Text="Select a production line" Value="" />
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator runat="server"
                            ControlToValidate="ProductionLineDropDownList" InitialValue=""
                            ValidationGroup="NewMeasurement" Display="None"
                            ErrorMessage="Production line is required." />
                    </div>
                </div>
                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="row align-items-center">
                            <label class="col-5 col-form-label">Temperature (&deg;C)</label>
                            <div class="col-7">
                                <asp:TextBox ID="TemperatureTextBox" runat="server" CssClass="form-control" TextMode="Number" step="any" />
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="TemperatureTextBox"
                                    ValidationGroup="NewMeasurement" Display="None" ErrorMessage="Temperature is required." />
                                <asp:CompareValidator runat="server" ControlToValidate="TemperatureTextBox"
                                    Operator="DataTypeCheck" Type="Double"
                                    ValidationGroup="NewMeasurement" Display="None" ErrorMessage="Temperature must be a number." />
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="row align-items-center">
                            <label class="col-5 col-form-label">Humidity (%)</label>
                            <div class="col-7">
                                <asp:TextBox ID="HumidityTextBox" runat="server" CssClass="form-control" TextMode="Number" step="any" min="0" max="100" />
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="HumidityTextBox"
                                    ValidationGroup="NewMeasurement" Display="None" ErrorMessage="Humidity is required." />
                                <asp:CompareValidator runat="server" ControlToValidate="HumidityTextBox"
                                    Operator="DataTypeCheck" Type="Double"
                                    ValidationGroup="NewMeasurement" Display="None" ErrorMessage="Humidity must be a number." />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="row align-items-center">
                            <label class="col-5 col-form-label">Weight (g)</label>
                            <div class="col-7">
                                <asp:TextBox ID="WeightTextBox" runat="server" CssClass="form-control" TextMode="Number" step="any" min="0" />
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="WeightTextBox"
                                    ValidationGroup="NewMeasurement" Display="None" ErrorMessage="Weight is required." />
                                <asp:CompareValidator runat="server" ControlToValidate="WeightTextBox"
                                    Operator="DataTypeCheck" Type="Double"
                                    ValidationGroup="NewMeasurement" Display="None" ErrorMessage="Weight must be a number." />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="row align-items-center">
                            <label class="col-5 col-form-label">Width (mm)</label>
                            <div class="col-7">
                                <asp:TextBox ID="WidthTextBox" runat="server" CssClass="form-control" TextMode="Number" step="any" min="0" />
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="WidthTextBox"
                                    ValidationGroup="NewMeasurement" Display="None" ErrorMessage="Width is required." />
                                <asp:CompareValidator runat="server" ControlToValidate="WidthTextBox"
                                    Operator="DataTypeCheck" Type="Double"
                                    ValidationGroup="NewMeasurement" Display="None" ErrorMessage="Width must be a number." />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="row align-items-center">
                            <label class="col-5 col-form-label">Length (mm)</label>
                            <div class="col-7">
                                <asp:TextBox ID="LengthTextBox" runat="server" CssClass="form-control" TextMode="Number" step="any" min="0" />
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="LengthTextBox"
                                    ValidationGroup="NewMeasurement" Display="None" ErrorMessage="Length is required." />
                                <asp:CompareValidator runat="server" ControlToValidate="LengthTextBox"
                                    Operator="DataTypeCheck" Type="Double"
                                    ValidationGroup="NewMeasurement" Display="None" ErrorMessage="Length must be a number." />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="row align-items-center">
                            <label class="col-5 col-form-label">Depth (mm)</label>
                            <div class="col-7">
                                <asp:TextBox ID="DepthTextBox" runat="server" CssClass="form-control" TextMode="Number" step="any" min="0" />
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="DepthTextBox"
                                    ValidationGroup="NewMeasurement" Display="None" ErrorMessage="Depth is required." />
                                <asp:CompareValidator runat="server" ControlToValidate="DepthTextBox"
                                    Operator="DataTypeCheck" Type="Double"
                                    ValidationGroup="NewMeasurement" Display="None" ErrorMessage="Depth must be a number." />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="mt-4">
                    <label class="form-label d-block">Result</label>
                    <asp:RadioButtonList ID="PassedRadioButtonList" runat="server"
                        RepeatDirection="Horizontal" RepeatLayout="Flow" CssClass="d-inline-flex gap-4">
                        <asp:ListItem Text="&nbsp;Pass" Value="1" Selected="True" />
                        <asp:ListItem Text="&nbsp;Fail" Value="0" />
                    </asp:RadioButtonList>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                <asp:Button ID="SaveMeasurementButton" runat="server" Text="Save Measurement"
                    CssClass="btn btn-primary" ValidationGroup="NewMeasurement"
                    OnClick="SaveMeasurementButton_Click" />
            </div>
        </div>
    </div>
</div>