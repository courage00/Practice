using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace linqtosql
{
	class Program
	{
		static void Main(string[] args)
		{

			AddEmployee(new Employees() { EmployeeName = "戴兆勇" , Salary=51230 });
			AddEmployee(new Employees() { EmployeeName = "村民A" , Salary = 51230 });

			//接下來 使用SqlDatareader查詢 Salary小於(<) 50000的資料
			//並列出依Salary升冪排序的第5~10筆(跳過前5筆後列出5筆)
			string[] saveid = new string[5];
			saveid = GetEmployeeUnderSalary(50000);
			for (int i = 0; i < 5; i++)
			{
				UpdateEmployeeResult(saveid[i], 51230);
				//使用程式修改 上述列出的5筆資料的Salary為51230(使用Employeeid為條件)
			};
			//Salary等於 51230的資料
			int id = QueryEmployee(51230);
			//使用程式刪除 上列結果的第一筆資料(使用Employeeid為條件)

			DeleteEmployee(id);
			Console.WriteLine("\n");
			//再次列出Salary等於 51230的資料
			QueryEmployee(51230);
		}

		private static int QueryEmployee(int Salary)
		{
			int id = 0;
			using (var db = new DataClasses1DataContext())
			{
				var list = db.Employees.Where(x => x.Salary == Salary);
				var list2=db.Employees.Where(x => x.Salary == Salary).FirstOrDefault();
				id = list2.EmployeeID;

				foreach (Employees e in list)
				{
					//將結果顯示在畫面上
					Console.WriteLine("{0}\t{1}\t{2}\t",
						e.EmployeeID, e.EmployeeName, e.Salary);
				}
			}
			
			Console.Read();
			return id;
			
		}
		private static String[] GetEmployeeUnderSalary(int Salary)
		{
			string[] saveid = new string[5];
			int i = 0;
			using (var db = new DataClasses1DataContext())
			{
				var list = db.Employees.Where(x => x.Salary < Salary).OrderBy(x => x.Salary).Take(10).Skip(5);

				foreach (Employees e in list)
				{
					//將結果顯示在畫面上
					Console.WriteLine("{0}\t{1}\t{2}\t",
						e.EmployeeID, e.EmployeeName, e.Salary);
					saveid[i] = e.EmployeeID.ToString();

					i++;
				}
			}
			Console.Read();
			return saveid;
		}

		/// <summary>
		///  LINQ新增
		/// </summary>
		/// <param name="obj"></param>
		private static void AddEmployee(Employees obj)
		{
			{
				using (var db = new DataClasses1DataContext())
				{
					db.Employees.InsertOnSubmit(obj);
					db.SubmitChanges();
				}

			}
		}

		/// <summary>
		///  LINQ刪除
		/// </summary>
		/// <param name="EmployeeID"></param>
		private static void DeleteEmployee(int EmployeeID)
		{
			using (var db = new DataClasses1DataContext())
			{
				var e = db.Employees.Where(x => x.EmployeeID == EmployeeID).FirstOrDefault();
				if (e != null)
				{
					db.Employees.DeleteOnSubmit(e);
					db.SubmitChanges();
				}
			}
		}

	    //更新結果
		private static void UpdateEmployeeResult(String EmployeeID, int Salary)
		{
			using (var db = new DataClasses1DataContext())
			{
				if (EmployeeID != null)
				{
					Int32.Parse(EmployeeID);
					int numVal = Int32.Parse(EmployeeID);
				
				  var list = db.Employees.Where(x => x.EmployeeID == numVal);
				  foreach (Employees e in list)
				  {
					e.Salary = Salary;
					db.SubmitChanges();
				  }
                }
			}
		}
	}
}
