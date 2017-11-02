<%@ Page Language="C#" %>
<%@ Import Namespace="System"%>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>
<%
	if (Request["action"] == "cancel")
	{
		Session["back"] = "true";
		Response.Redirect("Default.aspx");
	}


%>
<script runat="server">


	void Page_Load(Object sender, EventArgs e)
	{
		if (Session["from"].ToString()=="new")
		{
			Session["name"] = "";
			Session["title"] = "";
			Session["titlec"] = "";
			Session["bdate"] = "";
			Session["hdate"] = "";
			Session["address"] = "";
			Session["hphone"] = "";
			Session["ex"] = "";
			Session["photopath"] = "";
			Session["notes"] = "";
			Session["mgid"] = "";
			Session["salary"] = "";
		}

		else
		{
			string queryString = "";
			string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();
			using (SqlConnection connection = new SqlConnection(connectionString))
			{
				connection.Open();

				queryString = " select * from Employees where EmployeeID =@EmployeeID ";
				SqlCommand command = new System.Data.SqlClient.SqlCommand(queryString, connection);
				command.Parameters.AddWithValue("@EmployeeID", Session["from"].ToString());
				SqlDataReader reader = command.ExecuteReader();
				while (reader.Read())
				{
					Session["name"] = reader["EmployeeName"].ToString();
					Session["title"] = reader["Title"].ToString();
					Session["titlec"] = reader["TitleOfCourtesy"].ToString();
					Session["bdate"] = string.IsNullOrEmpty(reader["BirthDate"].ToString()) ? "" : DateTime.Parse(reader["BirthDate"].ToString()).ToString("yyyy/MM/dd");
					Session["hdate"] = string.IsNullOrEmpty(reader["HireDate"].ToString()) ? "" : DateTime.Parse(reader["HireDate"].ToString()).ToString("yyyy/MM/dd");
					Session["address"] = reader["Address"].ToString();
					Session["hphone"] = reader["HomePhone"].ToString();
					Session["ex"] = reader["Extension"].ToString();
					Session["photopath"] = reader["PhotoPath"].ToString();
					Session["notes"] = reader["Notes"].ToString();
					Session["mgid"] = reader["ManagerID"].ToString();
					Session["salary"] = reader["Salary"].ToString();
				}


			}
		}

	}
	void save(Object sender, EventArgs e)
	{
		DateTime date=new DateTime();
		if (String.IsNullOrEmpty(Request.Form["name"]))
		{
			Session["name"] = "";
			Response.Write("<font color='red'>EmployeeName未填寫</font>");
		}
		else if (String.IsNullOrEmpty(Request.Form["title"]))
		{
			Session["title"] = "";
			Session["name"] = Request.Form["name"].ToString();
			Response.Write("<font color='red'>Title未填寫</font>");
		}
		else if (String.IsNullOrEmpty(Request.Form["titlec"]))
		{
			Session["titlec"] = "";
			Session["title"] = Request.Form["title"].ToString();
			Response.Write("<font color='red'>TitleOfCourtesy未填寫y/m/d</font>");
		}
		else if (DateTime.TryParse(Request.Form["bdate"], out date) == false)
		{
			Session["bdate"] = "";
			Session["titlec"] = Request.Form["titlec"].ToString();
			Response.Write("<font color='red'>請輸入BirthDate正確格式y/m/d</font>");
		}
		else if (DateTime.TryParse(Request.Form["hdate"], out date) == false)
		{
			Session["hdate"] = "";
			Session["bdate"] = Request.Form["bdate"].ToString();
			Response.Write("<font color='red'>請輸入HireDate正確格式</font>");
		}
		else if (String.IsNullOrEmpty(Request.Form["address"]))
		{
			Session["address"] = "";
			Session["hdate"] = Request.Form["hdate"].ToString();
			Response.Write("<font color='red'>Address未填寫</font>");
		}
		else if (String.IsNullOrEmpty(Request.Form["hphone"] ))
		{
			Session["hphone"] = "";
			Session["address"] = Request.Form["address"].ToString();
			Response.Write("<font color='red'>HomePhone未填寫</font>");
		}
		else if (String.IsNullOrEmpty(Request.Form["ex"] ))
		{
			Session["ex"] = "";
			Session["hphone"] = Request.Form["hphone"].ToString();
			Response.Write("<font color='red'>Extension未填寫</font>");
		}
		else if (String.IsNullOrEmpty(Request.Form["photopath"] ))
		{
			Session["photopath"] = "";
			Session["ex"] = Request.Form["ex"].ToString();
			Response.Write("<font color='red'>PhotoPath未填寫</font>");
		}
		else if (String.IsNullOrEmpty(Request.Form["notes"] ))
		{
			Session["notes"] = "";
			Session["photopath"] = Request.Form["photopath"].ToString();
			Response.Write("<font color='red'>Notes未填寫</font>");
		}
		else if (String.IsNullOrEmpty(Request.Form["mgid"] ))
		{
			Session["mgid"] = "";
			Session["notes"] = Request.Form["notes"].ToString();
			Response.Write("<font color='red'>ManagerID未填寫</font>");
		}
		else if (String.IsNullOrEmpty(Request.Form["salary"] ))
		{
			Session["salary"] = "";
			Session["mgid"] = Request.Form["mgid"].ToString();
			Response.Write("<font color='red'>Salary未填寫</font>");
		}
		else
		{
			Session["name"] = Request.Form["name"].ToString();
			Session["title"] = Request.Form["title"].ToString();
			Session["titlec"] = Request.Form["titlec"].ToString();
			Session["bdate"] = Request.Form["bdate"].ToString();
			Session["hdate"] = Request.Form["hdate"].ToString();
			Session["address"] = Request.Form["address"].ToString();
			Session["hphone"] = Request.Form["hphone"].ToString();
			Session["ex"] = Request.Form["ex"].ToString();
			Session["photopath"] = Request.Form["photopath"].ToString();
			Session["notes"] = Request.Form["notes"].ToString();
			Session["mgid"] = Request.Form["mgid"].ToString();
			Session["salary"] = Request.Form["salary"].ToString();

			string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();

			using (SqlConnection connection = new SqlConnection(connectionString))
			{
				connection.Open();
				string queryString = " insert into Employees (EmployeeName,Title,TitleOfCourtesy,BirthDate,HireDate,Address,HomePhone,Extension,PhotoPath,Notes,ManagerID,Salary) values(@EmployeeName,@Title,@TitleOfCourtesy,@BirthDate,@HireDate,@Address,@HomePhone,@Extension,@PhotoPath,@Notes,@ManagerID,@Salary)";
				if (Session["from"].ToString() != "new")
				{
					queryString=" update Employees set  EmployeeName=@EmployeeName,Title=@Title,TitleOfCourtesy=@TitleOfCourtesy,BirthDate=@BirthDate,HireDate=@HireDate,Address=@Address,HomePhone=@HomePhone,Extension=@Extension,PhotoPath=@PhotoPath,Notes=@Notes,ManagerID=@ManagerID,Salary=@Salary where EmployeeID=@EmployeeID";
				}
				SqlCommand command = new SqlCommand(queryString, connection);
				command.Parameters.AddWithValue("@EmployeeName", Session["name"].ToString());
				command.Parameters.AddWithValue("@Title",Session["title"].ToString() );
				command.Parameters.AddWithValue("@TitleOfCourtesy",Session["titlec"].ToString() );
				command.Parameters.AddWithValue("@BirthDate",Session["bdate"].ToString() );
				command.Parameters.AddWithValue("@HireDate",Session["hdate"].ToString() );
				command.Parameters.AddWithValue("@Address",Session["address"].ToString() );
				command.Parameters.AddWithValue("@HomePhone",Session["hphone"].ToString() );
				command.Parameters.AddWithValue("@Extension",Session["ex"].ToString() );
				command.Parameters.AddWithValue("@PhotoPath",Session["photopath"].ToString() );
				command.Parameters.AddWithValue("@Notes",Session["notes"].ToString() );
				command.Parameters.AddWithValue("@ManagerID",Session["mgid"].ToString() );
				command.Parameters.AddWithValue("@Salary", Session["salary"].ToString());
				command.Parameters.AddWithValue("@EmployeeID", Session["from"].ToString());

				command.ExecuteNonQuery();
			}
			Session["salary"] = "";
			Session["back"] = "true";
			Response.Redirect("Default.aspx");
		}

	}
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table>
				<%

	
				%>
                <tr>
                    <th>EmployeeName</th>
                    <td>
                        <input id="name" name="name" type="text" value="<%=Session["name"].ToString() %>" />
                    </td>
                </tr>
                <tr>
                    <th>Title</th>
                    <td>
                        <input id="title" name="title" type="text" value="<%=Session["title"].ToString() %>" />
                    </td>
                </tr>
                <tr>
                    <th>TitleOfCourtesy</th>
                    <td>
                        <input id="titlec" name="titlec" type="text" value="<%=Session["titlec"].ToString() %>" />
                    </td>
                </tr>
                <tr>
                    <th>BirthDate</th>
                    <td>
                        <input id="bdate" name="bdate" type="text" value="<%=Session["bdate"].ToString() %>" />
                    </td>
                </tr>
                <tr>
                    <th>HireDate</th>
                    <td>
                        <input id="hdate" name="hdate" type="text" value="<%=Session["hdate"].ToString() %>" />
                    </td>
                </tr>
                <tr>
                    <th>Address</th>
                    <td>
                        <input id="address" name="address" type="text" value="<%=Session["address"].ToString() %>" />
                    </td>
                </tr>
                <tr>
                    <th>HomePhone</th>
                    <td>
                        <input id="hphone" name="hphone" type="text" value="<%=Session["hphone"].ToString() %>"/>
                    </td>
                </tr>
                <tr>
                    <th>Extension</th>
                    <td>
                        <input id="ex" name="ex" type="text" value="<%=Session["ex"].ToString() %>"/>
                    </td>
                </tr>
                <tr>
                    <th>PhotoPath</th>
                    <td>
                        <input id="photopath" name="photopath"  type="text" value="<%=Session["photopath"].ToString() %>" />
                    </td>
                </tr>
                <tr>
                    <th>Notes</th>
                    <td>
                        <input id="notes" name="notes" type="text"value="<%=Session["notes"].ToString() %>" />
                    </td>
                </tr>
                <tr>
                    <th>ManagerID</th>
                    <td>
                        <input id="mgid" name="mgid" type="text"value="<%=Session["mgid"].ToString() %>" />
                    </td>
                </tr>
                <tr>
                    <th>Salary</th>
                    <td>
                        <input id="salary" name="salary" type="text"value="<%=Session["salary"].ToString() %>" />
                    </td>
                </tr>

                <tr>
                    <th colspan="2" style="text-align: center">
                        <button type="submit" name="action" value="save" onserverclick="save"  runat="server">存檔</button>
                        <button type="submit" name="action" value="cancel">取消</button>
                    </th>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
