<%@ Page Language="C#" %>
<%@ Import Namespace="System"%>
<%@ Import Namespace="System.Data"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<%
	//判斷按鈕
	if ( Request["action"] == "new")
	{
		Session["from"] = "new";
		Response.Redirect("Edit.aspx");
	}
	if ( Request["action"] == "edit")
	{
		Response.Redirect("Edit.aspx");
	}

%>
<script runat="server">

	void Page_Load(Object sender, EventArgs e)
	{
		//判斷是否為edit頁面返回 如不是則初始設置
		if (Session["back"] == null)
		{
			if (!IsPostBack)
			{
				Session["page"] = "1";//當前頁數
				Session["querytitletext"] = "";//搜尋的職務
				Session["querynametext"] = "";//搜尋的姓名
				Session["mode"] = "normal";//目前模式 分成搜尋 跟 一般
			}
		}

		//抓搜尋 跟初始顯示的頁數
		string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();
		using (SqlConnection connection = new SqlConnection(connectionString))
		{
			connection.Open();
			int endpage = 0 ,datacount = 0;//總頁數 總比數
			int pagelistnum = 5;//每頁顯示數
			string querynametext = Request.Form["querynametext"];
			string querytitletext = Request.Form["querytitletext"];
			if (Session["back"] != null)//從編輯頁面回來的話從session取值
			{
				querynametext = Session["querynametext"].ToString();
				querytitletext = Session["querytitletext"].ToString();
			}
			string queryString = "";
			string mode = Session["mode"].ToString();
			if (mode == "query")
			{
				queryString = " select count(EmployeeName) from Employees where EmployeeName like '%'+@EmployeeName+'%' and Title like '%'+@Title+'%'  ";
				SqlCommand command = new System.Data.SqlClient.SqlCommand(queryString, connection);
				command.Parameters.AddWithValue("@EmployeeName",querynametext );
				command.Parameters.AddWithValue("@Title",querytitletext );
				datacount=(int)command.ExecuteScalar();
				//每五筆一頁
				if (datacount<=5)
				{
					nextbtn.Disabled = true;
					tlastbtn.Disabled = true;
				}
				else
				{
					nextbtn.Disabled = false;
					tlastbtn.Disabled = false;
				}
			}
			else
			{
				queryString = " select EmployeeName,Title,BirthDate,Address,Salary from Employees order by  EmployeeID ";
				SqlCommand command = new System.Data.SqlClient.SqlCommand(queryString, connection);
				SqlDataReader reader = command.ExecuteReader();
				while (reader.Read())
				{
					datacount=datacount+1;
				}

			}

			if (datacount % pagelistnum == 0)//餘數為0
			{
				endpage = datacount / pagelistnum;
			}
			else //餘數不等於 0 時
			{
				endpage = datacount / pagelistnum + 1;
			}
			//總共頁數
			Session["endpage"] = endpage.ToString();
		}
	}
	//查詢按鈕
	void querypage(Object sender, EventArgs e)
	{
		Session["page"] = "1";
		Session["mode"] = "query";
		Session["back"] = null;

		firstbtn.Disabled=true;
		lastbtn.Disabled=true;
		Page_Load(sender,e);

	}
	//第一頁
	void firstpage(Object sender, EventArgs e)
	{
		Session["page"] = "1";

		firstbtn.Disabled=true;
		lastbtn.Disabled=true;
		nextbtn.Disabled = false;
		tlastbtn.Disabled = false;
	}
	//上一頁
	void tlastpage(Object sender, EventArgs e)
	{
		Session["page"] = Session["endpage"].ToString();

		firstbtn.Disabled=false;
		lastbtn.Disabled= false;
		nextbtn.Disabled = true;
		tlastbtn.Disabled = true;

	}
	//下一頁
	void lastpage(Object sender, EventArgs e)
	{
		string page=Session["page"].ToString();
		int pageint =int.Parse(page);
		pageint = pageint - 1;
		Session["page"] = pageint.ToString();

		nextbtn.Disabled = false;
		tlastbtn.Disabled = false;

		if (pageint == 1)
		{
			firstbtn.Disabled=true;
			lastbtn.Disabled=true;
		}
		else
		{
			nextbtn.Disabled = false;
			tlastbtn.Disabled = false;
		}
	}
	//最後一頁
	void nextpage(Object sender, EventArgs e)
	{
		string page=Session["page"].ToString();
		int pageint =int.Parse(page);
		pageint = pageint + 1;
		Session["page"] = pageint.ToString();

		string endpage=Session["endpage"].ToString();
		int endpageint =int.Parse(endpage);

		firstbtn.Disabled=false;
		lastbtn.Disabled=false;
		if (pageint == endpageint)
		{
			nextbtn.Disabled = true;
			tlastbtn.Disabled = true;
		}
		else
		{
			nextbtn.Disabled = false;
			tlastbtn.Disabled = false;
		}
	}
	//每個edit按鈕的處發函式
	void editbtn1(Object sender, EventArgs e)
	{
		Session["from"]=Session["edit1"];
	}
	void editbtn2(Object sender, EventArgs e)
	{
		Session["from"]=Session["edit2"];
	}
	void editbtn3(Object sender, EventArgs e)
	{
		Session["from"]=Session["edit3"];
	}
	void editbtn4(Object sender, EventArgs e)
	{
		Session["from"]=Session["edit4"];
	}
	void editbtn5(Object sender, EventArgs e)
	{
		Session["from"]=Session["edit5"];
	}
	//每個刪除按鈕的觸發函式
	void delete1(Object sender, EventArgs e)
	{
		string  queryString = Session["btn1"].ToString();
		string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();
		using (SqlConnection connection = new SqlConnection(connectionString))
		{
			connection.Open();
			SqlCommand command = new SqlCommand(queryString, connection);
			command.ExecuteNonQuery();
		}
	}
	void delete2(Object sender, EventArgs e)
	{
		string  queryString = Session["btn2"].ToString();
		string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();
		using (SqlConnection connection = new SqlConnection(connectionString))
		{
			connection.Open();
			SqlCommand command = new SqlCommand(queryString, connection);
			command.ExecuteNonQuery();
		}
	}
	void delete3(Object sender, EventArgs e)
	{
		string  queryString = Session["btn3"].ToString();
		string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();
		using (SqlConnection connection = new SqlConnection(connectionString))
		{
			connection.Open();
			SqlCommand command = new SqlCommand(queryString, connection);
			command.ExecuteNonQuery();
		}
	}
	void delete4(Object sender, EventArgs e)
	{
		string  queryString = Session["btn4"].ToString();
		string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();
		using (SqlConnection connection = new SqlConnection(connectionString))
		{
			connection.Open();
			SqlCommand command = new SqlCommand(queryString, connection);
			command.ExecuteNonQuery();
		}
	}
	void delete5(Object sender, EventArgs e)
	{
		string  queryString = Session["btn5"].ToString();
		string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();
		using (SqlConnection connection = new SqlConnection(connectionString))
		{
			connection.Open();
			SqlCommand command = new SqlCommand(queryString, connection);
			command.ExecuteNonQuery();
		}
	}
</script>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table>
                <thead>
                    <tr>
                        <th>
							<%
								string mode = Session["mode"].ToString();
								string querytitletext = "";
								string querynametext = "";
								if (mode == "query")
								{
									if (Session["back"] == null)//根據back是否null知道是不是編輯或新增回來後的頁面
									{
										Session["querynametext"] = Request.Form["querynametext"];
										querynametext = Session["querynametext"].ToString();
										Session["querytitletext"] = Request.Form["querytitletext"];
										querytitletext = Session["querytitletext"].ToString();
									}
									else
									{
										querynametext = Session["querynametext"].ToString();
										querytitletext = Session["querytitletext"].ToString();

									}
								}
							%>
                            <input id="querynametext" name="querynametext"  type="text" placeholder="查詢姓名" value="<%=querynametext%>"/>

                        </th>
                        <th>
                            <input id="querytitletext" name="querytitletext" type="text" placeholder="查詢職稱" value="<%=querytitletext %>" />
                        </th>
                        <th colspan="4">
                            <button id="querybtn" onserverclick="querypage" type="submit" runat="server" >查詢</button>
                        </th>
                    </tr>
                    <tr>
                        <th>姓名</th>
                        <th>職稱</th>
                        <th>生日</th>
                        <th>住址</th>
                        <th>薪資</th>
                        <th>
                            <button type="submit" name="action" value="new">新增</button></th>
                    </tr>
                </thead>
                <tbody id="tbody">
                    <%  string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ToString();
						using (SqlConnection connection = new SqlConnection(connectionString))
						{
							connection.Open();
							string page=Session["page"].ToString();
							int pageint =int.Parse(page);
							int endid, startid,deleteid;
							endid = pageint * 5;
							startid = endid - 5;
							deleteid = startid;

							string queryString = "";
							queryString = " select EmployeeID,EmployeeName,Title,BirthDate,Address,Salary from Employees where EmployeeName like '%'+@EmployeeName+'%'and Title like '%'+@Title+'%' order by  EmployeeID offset @startid rows fetch next 5 rows only";
							
							SqlCommand command = new System.Data.SqlClient.SqlCommand(queryString, connection);
							command.Parameters.AddWithValue("@EmployeeName",querynametext );
							command.Parameters.AddWithValue("@Title", querytitletext);
							command.Parameters.AddWithValue("@startid",startid );
							SqlDataReader reader = command.ExecuteReader();
							int i = 1;
							while (reader.Read())
							{
								string name, title, address, birthdate, salary,id;
								name = reader["EmployeeName"].ToString();
								title = reader["Title"].ToString();
								birthdate = string.IsNullOrEmpty(reader["BirthDate"].ToString()) ? "" : DateTime.Parse(reader["BirthDate"].ToString()).ToString("yyyy/MM/dd");
								address = reader["Address"].ToString();
								salary = reader["Salary"].ToString();
								id= reader["EmployeeID"].ToString(); 
	                             %>
                                    <tr>
                                    <td><% =name      %></td>
                                    <td><% =title     %></td>
								    <td><% =birthdate %></td>
                                    <td><% =address   %></td>
                                    <td><% =salary    %></td>
                                    <td>
                                        <%//替按鈕上名子
										  if (i == 1) {%> <button type="submit" id="edit1" name="action" value="edit" onserverclick="editbtn1" runat="server" >編輯</button> <button type="submit" id="btn1" name="action" value="delete" onserverclick="delete1" runat="server" >刪除</button><%}
                                          if (i == 2) {%> <button type="submit" id="edit2" name="action" value="edit" onserverclick="editbtn2" runat="server" >編輯</button><button type="submit" id="btn2" name="action" value="delete" onserverclick="delete2" runat="server" >刪除</button><%}
										  if (i == 3) {%> <button type="submit" id="edit3" name="action" value="edit" onserverclick="editbtn3" runat="server" >編輯</button><button type="submit" id="btn3" name="action" value="delete" onserverclick="delete3" runat="server" >刪除</button><%}														
                                          if (i == 4) {%> <button type="submit" id="edit4" name="action" value="edit" onserverclick="editbtn4" runat="server" >編輯</button><button type="submit" id="btn4" name="action" value="delete" onserverclick="delete4" runat="server" >刪除</button><%}
										  if (i == 5) {%> <button type="submit" id="edit5" name="action" value="edit" onserverclick="editbtn5" runat="server" >編輯</button><button type="submit" id="btn5" name="action" value="delete" onserverclick="delete5" runat="server" >刪除</button><%}
                                          Session["btn"+i] = " delete from  Employees where Employeeid="+id;
                                          Session["edit"+i] = id;
									    %>
                                    </td>
                                    </tr>
                                 <%
											 i++;
										 }
										 reader.Close();
									 }
									 if (Session["page"].ToString() == "1")
									 {
										 firstbtn.Disabled=true;
										 lastbtn.Disabled=true;
									 }
									 if (Session["endpage"].ToString() == Session["page"].ToString())
									 {
										 nextbtn.Disabled = true;
										 tlastbtn.Disabled = true;
									 }

							 %>		
	                       						    
                </tbody>
            </table>
            <table>
                <tr>
                    <td><button id="firstbtn" type="submit" onserverclick="firstpage"  runat="server" >第一頁</button></td>
                    <td><button id="lastbtn" type="submit" onserverclick="lastpage"    runat="server" >上一頁</button></td>
                    <td><button id="nextbtn" type="submit" onserverclick="nextpage"    runat="server" >下一頁</button></td>
					<td><button id="tlastbtn" type="submit" onserverclick="tlastpage"  runat="server" >最後頁</button></td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
