


--	SQL Server Management Objects Uygulamalarý


Microsoft.SqlServer.ConnectionInfo
Microsoft.SqlServer.Management.Sdk.Sfc
Microsoft.SqlServer.Smo
Microsoft.SqlServer.SmoExtended
Microsoft.SqlServer.SqlEnum
Microsoft.SqlServer.SmoEnum


--	SMO ile Sunucu Baðlantýsý Oluþturmak


ServerConnection conn = new ServerConnection();
conn.LoginSecure = true;
Server svr = new Server(conn);
svr.ConnectionContext.Connect();


ServerConnection conn = new ServerConnection("dijibil-pc","sa","cihan..");


conn.LoginSecure = true;
Server svr = new Server(conn);
svr.ConnectionContext.Connect();


--	Sunucu Özelliklerini Elde Etmek


Server srv = new Server(conn);
listBox1.Items.Add("Sunucu: " + srv.Name);
listBox1.Items.Add("Versiyon: " + srv.Information.Edition);
listBox1.Items.Add("Veritabaný Sayýsý : " + srv.Databases.Count);
listBox1.Items.Add("Instance Adý : " + srv.InstanceName);
listBox1.Items.Add("Net Adý : " + srv.NetName);
listBox1.Items.Add("Sunucu Tipi : " + srv.ServerType);
listBox1.Items.Add("Yayýn : " + srv.Information.Edition);
listBox1.Items.Add("Dil : " + srv.Information.Language);
listBox1.Items.Add("Ý.S Versiyon : " + srv.Information.OSVersion);
listBox1.Items.Add("Platform : " + srv.Information.Platform);
listBox1.Items.Add("Ürün Seviye : " + srv.Information.ProductLevel);
listBox1.Items.Add("Versiyon : " + srv.Information.Version + " " 
                                 + srv.Information.VersionMajor + " "
                                 + srv.Information.VersionMinor);
listBox1.Items.Add("Yapý Numarasý : " + srv.Information.BuildNumber);
listBox1.Items.Add("Collation : " + srv.Information.Collation);


--	Veritabanlarý, Dosya Gruplarý ve Dosyalarýn Listesini Almak


Server srv = new Server(conn);
foreach (Database db in srv.Databases)
{
   listBox1.Items.Add(db.Name);
   foreach (FileGroup fg in db.FileGroups)
   {
      listBox2.Items.Add(" " + fg.Name);
      foreach (DataFile df in fg.Files)
      {
         listBox3.Items.Add(" " + df.Name + " - " + df.FileName);
      }
   }
}


--	Veritabaný Özelliklerini Almak


Server srv = new Server(conn);
Database database = srv.Databases["AdventureWorks"];
foreach (Property prop in database.Properties)
{
    listBox1.Items.Add(prop.Name + " - " + prop.Value);
}


--	Sunucudaki Tüm Veritabanlarýný Listelemek


Server srv = new Server(conn);
srv.ConnectionContext.Connect();
Database db = srv.Databases["AdventureWorks"];

foreach (Database vt in srv.Databases)
{
    ListBox1.Items.Add(vt.Name.ToString());
}



--	Veritabaný Oluþturmak


void VeritabaniOlustur(string vt_ad)
{
    Server srv = new Server(conn);
    Database database = new Database(srv, "" + vt_ad + "");
    database.FileGroups.Add(new FileGroup(database, "PRIMARY"));
    DataFile dtPrimary = new DataFile(database.FileGroups["PRIMARY"],
				 	    			"Data", @"C:\Databases\" 
				          			+ vt_ad + ".mdf");
    dtPrimary.Size = 77.0 * 1024.0;
    dtPrimary.GrowthType = FileGrowthType.KB;
    dtPrimary.Growth = 1.0 * 1024.0;
    database.FileGroups["PRIMARY"].Files.Add(dtPrimary);

    LogFile logFile = new LogFile(database, "Log", 
					    @"C:\Databases\" 
					    + vt_ad + ".ldf");
    logFile.Size = 7.0 * 1024.0;
    logFile.GrowthType = FileGrowthType.Percent;
    logFile.Growth = 10.0;

    database.LogFiles.Add(logFile);
    database.Create();
    database.Refresh();
}



Microsoft.SqlServer.SqlEnum



VeritabaniOlustur(txtVeritabani.Text);



--	Veritabaný Yedeklemek


void Yedekle(string vt_ad)
{
	listBox1.Items.Clear();
	Random rnd = new Random();
	Server srv = new Server(conn);
	Database database = srv.Databases["" + vt_ad + ""];
	Backup backup = new Backup();
	backup.Action = BackupActionType.Database;
	backup.Database = database.Name;
	backup.Devices.AddDevice(@"C:\Backups\Backup" 
					 + rnd.Next(1, 10000) 
					 +".bak", 
					 DeviceType.File); 
	backup.PercentCompleteNotification = 10;
	backup.PercentComplete += new 									PercentCompleteEventHandler(backup_PercentComplete);
	backup.SqlBackup(srv);
}



void backup_PercentComplete(object sender, PercentCompleteEventArgs e)
{
   listBox1.Items.Add("%" + e.Percent + " tamamlandý.");
}



Yedekle(txtVeritabaniAd.Text);



--	Veritabaný Geri Yüklemek



void VeritabaniGeriYukle(string vt_ad, string yedek_ad)
{
    Server srv = new Server(conn);
    Restore restore = new Restore();
    string fileName = @"C:\Backups\" + yedek_ad + ".bak";
    string databaseName = "" + vt_ad + "";

    restore.Database = databaseName;
    restore.Action = RestoreActionType.Database;
    restore.Devices.AddDevice(fileName, DeviceType.File);

    this.progressBar1.Value = 0;
    this.progressBar1.Maximum = 100;
    this.progressBar1.Value = 10;

    restore.PercentCompleteNotification = 10;
    restore.ReplaceDatabase = true;
    restore.PercentComplete += new 											PercentCompleteEventHandler(res_PercentComplete);
    restore.SqlRestore(srv);
}



void restore_PercentComplete(object sender, PercentCompleteEventArgs e)
{
    progressBar1.Value = e.Percent;
    listBox1.Items.Add("%" + e.Percent + " tamamlandý.");
}



--	Veritabanýný Silmek


void VeritabaniSil(string vt_ad)
{ 
    Server srv = new Server(conn);
    Database db = srv.Databases["" + vt_ad + ""];
    db.Drop();
}



VeritabaniSil(txtVeritabani.Txt);



--	Tablo ve Sütunlarý Listelemek



void Getir()
{
    Server srv = new Server(conn);
    Database db = srv.Databases["AdventureWorks"];
    
    foreach (Table table in db.Tables)
    {
        treeView1.Nodes.Add(" " + table.Name);
        foreach (Column col in table.Columns)
        {
	      treeView1.Nodes.Add("   -> " + col.Name + " - " 
							+ col.DataType.Name);
        }
    }
}



--	View Oluþturmak


void ViewOlustur(string vt_ad, string view_ad, 
		     string view_header, string view_body)
{
   try
   {
	Server srv = new Server(conn);
	Database database = srv.Databases["" + vt_ad + ""];

	Microsoft.SqlServer.Management.Smo.View myview = new 						Microsoft.SqlServer.Management.Smo.View(database, "" + 
									     view_ad + "");
	myview.TextHeader = "" + view_header + "";
	myview.TextBody = "" + view_body + "";
	myview.Create();
	MessageBox.Show(view_ad + " adýndaki view baþarýyla oluþturuldu");
   }
   catch (Exception ex)
   {
	MessageBox.Show(ex.Message);
   }  
}



ViewOlustur(txtVeritabaniAd.Text, txtViewAd.Text, 
	     txtViewHeader.Text, txtViewBody.Text);



SELECT * FROM vw_Urunler;


--	Stored Procedure Oluþturmak


void ProsedurOlustur(string vt_ad, string pr_ad, string pr_govde, 
								  string param_ad)
{
    try
    {
        Server srv = new Server(conn);
        Database database = srv.Databases["" + vt_ad + ""];
        
        StoredProcedure sp = new StoredProcedure(database, "" 
								  + pr_ad + "");
        sp.TextMode = false;
        sp.AnsiNullsStatus = false;
        sp.QuotedIdentifierStatus = false;
        StoredProcedureParameter param = new StoredProcedureParameter
						(sp, "@" + param_ad + "", DataType.Int);
        sp.Parameters.Add(param);
        string spBody = "" + pr_govde + " = @" + param_ad + "";
        sp.TextBody = spBody;
        sp.Create();
     }
     catch (Exception ex)
     {
        MessageBox.Show("Hata : " + ex.Message);
     }
}



ProsedurOlustur(txtVeritabaniAd.Text, txtProsedurAd.Text, 
		   txtProsedurGovde.Text, txtParametreAd.Text);



pr_UrunGetir 1;


--	Bir Stored Procedure'ü Oluþturmak, Deðiþtirmek ve Silmek


void ProsedurDegistir(string vt_ad, string prosedur_ad, 
			    string prosedur_govde, string param_ad1, 
			    string param_ad2)
{
    Server srv = new Server(conn);
    srv.ConnectionContext.Connect();
    Database db = srv.Databases["" + vt_ad + ""];

    StoredProcedure sp = new StoredProcedure(db, "" + prosedur_ad + "");

    sp.TextMode = false;
    sp.AnsiNullsStatus = false;
    sp.QuotedIdentifierStatus = false;

    StoredProcedureParameter param = new StoredProcedureParameter(sp, 
									"@" + param_ad1 + "",
										DataType.Int);
    sp.Parameters.Add(param);

    StoredProcedureParameter param2 = new StoredProcedureParameter(sp, 
									"@" + param_ad2 + "", 								     DataType.NVarChar(50));
    param2.IsOutputParameter = true;
    sp.Parameters.Add(param2);

    string sql = prosedur_govde;
    sp.TextBody = sql;

    sp.Create();
    sp.QuotedIdentifierStatus = true;
    listBox1.Items.Add("Prosedür oluþturuldu.");

    sp.Alter();
    listBox1.Items.Add("Prosedür deðiþtirildi.");

    sp.Drop();
    listBox1.Items.Add("Prosedür silindi.");
}



ProsedurDegistir(txtVeritabaniAd.Text, 
		     txtProsedurAd.Text, 
		     txtProsedurGovde.Text, 
		     txtParametre1Ad.Text, 
		     txtParametre2Ad.Text);


--	Veritabanýndaki Tüm Stored Procedure'leri Þifrelemek



void ProsedurleriSifrele(string vt_ad)
{
   string dbRequested = vt_ad;

   var srv = new Server();
   try
   {
      srv = new Server(conn);
   }
   catch(Exception ex)
   {
      MessageBox.Show("Hata : " + ex.Message);
      Environment.Exit(Environment.ExitCode);
   }

   var db = new Database();
   try
   {
      db = srv.Databases[dbRequested];
      if (db == null)
      throw new Exception();
   }
   catch(Exception ex)
   {
      MessageBox.Show("Hata : " + ex.Message);
      Environment.Exit(Environment.ExitCode);
   }

   var sp = new StoredProcedure();
   for (int i = 0; i < db.StoredProcedures.Count; i++)
   {
      sp = db.StoredProcedures[i];
      if (!sp.IsSystemObject)        
      {
         if (!sp.IsEncrypted)       
         {
           sp.TextMode = false;
           sp.IsEncrypted = true;
           sp.TextMode = true;
           sp.Alter();
           listBox1.Items.Add(" " + sp.Name + Environment.NewLine);                        
         }
      }
   }
}



ProsedurleriSifrele("AdventureWorks");



--	Þema Oluþturmak


void SemaOlustur(string vt_ad, string sema_ad, string tablo_ad, 
					  string id_sutun, string sutun_ad1)
{
    try
    {
        Server srv = new Server(conn);
        Database database = srv.Databases["" + vt_ad + ""];

        Schema schema = new Schema(database, "" + sema_ad + "");
        schema.Owner = "dbo";
        schema.Create();

        Table Kullanicilar = new Table(database, "" + tablo_ad + "", "" 
							           + sema_ad + "");

        DataType dt = new DataType(SqlDataType.Int);
        Column IDSutunu = new Column(Kullanicilar, "" + id_sutun + "", dt);
        IDSutunu.Nullable = false;
        IDSutunu.Identity = true;
        IDSutunu.IdentityIncrement = 1;
        IDSutunu.IdentitySeed = 1;
        Kullanicilar.Columns.Add(IDSutunu);
        dt = new DataType(SqlDataType.VarChar, 50);
        Column AdSutunu = new Column(Kullanicilar, "" + sutun_ad1 
									 + "", dt);
        Kullanicilar.Columns.Add(AdSutunu);
        Kullanicilar.Create();
        MessageBox.Show("Þema ve tablo baþarýyla oluþturuldu.");
    }
    catch (Exception ex)
    {
        MessageBox.Show("Hata : " + ex.Message);
    }
}




SemaOlustur(txtVeritabaniAd.Text, 
	     txtSemaAd.Text, 
	     txtTabloAd.Text, 
	     txtIDSutun.Text, 
	     txtNormalSutunAd.Text);



--	Þemalarý Listelemek


void SemalariListele()
{
   Server srv = new Server(conn);
   Database database = srv.Databases["AdventureWorks2012"];
   foreach (Schema schema in database.Schemas)
   {
       lstSemalar.Items.Add(schema.Name);
   }
}



SemalariListele();


--	Linked Server Oluþturmak


Server srv = new Server(@"Instance_A");
LinkedServer lsrv = new LinkedServer(srv, "Instance_B");
LinkedServerLogin login = new LinkedServerLogin();
login.Parent = lsrv;
login.Name = "Login_Instance_A";
login.RemoteUser = "Login_Instance_B";
login.SetRemotePassword("sifre");
login.Impersonate = false;
lsrv.ProductName = "SQL Server";
lsrv.Create();
login.Create();


--	Oturum Oluþturmak



void LoginOlustur(string login_ad, string sifre, string rol_ad)
{
    Server srv = new Server(conn);
    Login login = new Login(srv, "" + login_ad + "");
    login.LoginType = LoginType.SqlLogin;
    login.Create("" + sifre + "");
    login.AddToRole("" + rol_ad + "");
}



LoginOlustur(txtOturumAd.Text, txtSifre.Text, txtRol.Text);


--	Oturumlarý Listelemek


void LoginleriListele()
{
    Server srv = new Server(conn);
    foreach (Login login in srv.Logins)
    {
        lstLoginler.Items.Add(" -- " + login.Name);
        if (login.EnumDatabaseMappings() != null)
        {
            foreach (DatabaseMapping map in login.EnumDatabaseMappings())
            {
                lstLoginler.Items.Add(" --> Veritabaný : " + map.DBName);
                lstLoginler.Items.Add(" --> Kullanýcý : " + map.UserName);
            }
        }
    }
}



LoginleriListele();


--	Kullanýcý Oluþturmak



void KullaniciOlustur(string vt_ad, string kullanici_ad, string login_ad)
{
    Server srv = new Server(conn);
    Database db = srv.Databases["" + vt_ad + ""];
    User u = new User(db, "" + kullanici_ad + "");
    u.Login = "" + login_ad + "";
    u.Create();
}


KullaniciOlustur(txtVeritabani.Text, txtKullanici.Text, txtLogin.Text);


--	Kullanýcýlarý Listelemek



Server srv = new Server(conn);
Database db = srv.Databases["" + vt_ad + ""];
foreach (User user in db.Users)
{
    lstKullanicilar.Items.Add("Kullanýcý ID : " + user.ID);
    lstKullanicilar.Items.Add("Kullanýcý : " + user.Name);
    lstKullanicilar.Items.Add("Oturum : " + user.Login);
    lstKullanicilar.Items.Add("Varsayýlan Þema : " + user.DefaultSchema);
    lstKullanicilar.Items.Add("Oluþturulma Tarih : " + user.CreateDate);
    lstKullanicilar.Items.Add("-------------------");
}


KullaniciListele(txtVeritabani.Text);



--	Rol Oluþturmak


void RolOlustur(string vt_ad, string rol_ad)
{
    Server srv = new Server(conn);
    Database db = srv.Databases["" + vt_ad + ""];
    DatabaseRole dbRole = new DatabaseRole(db, "" + rol_ad + "");
    dbRole.Create();
}



RolOlustur(txtVeritabani.Text, txtRolAd.Text);


--	Rolleri Listelemek


void RolleriListele(string vt_ad)
{
    lstRoller.Items.Add("Ad : " + dr.Name);
    lstRoller.Items.Add("Oluþturma Tarihi : " + dr.CreateDate);
    lstRoller.Items.Add("Sahibi : " + dr.Owner);
    lstRoller.Items.Add("Rol Üyeleri :");
        foreach (string s in dr.EnumMembers())
            lstRoller.Items.Add("  " + s);
    lstRoller.Items.Add("--------------------");
}



RolleriListele(txtVeritabani.Text);



--	Rol Atamak


void KullaniciRolAtama(string vt_ad, string kullanici_ad, string rol)
{
    Server srv = new Server(conn);
    Database db = srv.Databases["" + vt_ad + ""];
    User u = db.Users["" + kullanici_ad + ""];
    u.AddToRole("" + rol + "");
    u.Alter();
}



KullaniciRolAtama(txtVeritabani.Text, txtKullanici.Text, txtRol.Text);


--	Assembly'leri Listelemek


void Assemblyler(string vt_ad)
{
    Server srv = new Server(conn);
    Database db = srv.Databases["" + vt_ad + ""];

    foreach (SqlAssembly assembly in db.Assemblies)
    {
        lstAssemblyler.Items.Add("Assembly Adý : " + " " + assembly.Name);
        foreach (SqlAssemblyFile assemblyFile in assembly.SqlAssemblyFiles)
              lstAssemblyler.Items.Add("  " + assemblyFile.Name);
    }
}


Assemblyler(txtVeritabani.Text);


--	Bir Tablonun Script'ini Oluþturmak


string ScriptOlustur(string vt_ad, string tablo_ad, string sema_ad)
{
    Server srv = new Server(conn);
    srv.ConnectionContext.Connect();

    Database db = srv.Databases["" + vt_ad + ""];
    Table tablo = db.Tables["" + tablo_ad + "", "" + sema_ad + ""];
    StringCollection script = tablo.Script();
    string sql_script = string.Empty;

    foreach (string s in script)
    {
        sql_script = sql_script + s;
    }
    return sql_script;
}




ScriptOlustur(txtVeritabani.Text, txtTablo.Text, txtSema.Text);

































































