#tag Class
Protected Class App
Inherits Application
	#tag Event
		Sub Open()
		  'Call RegisterControls.Register("Name", "Serial")
		  
		  
		  //Initializing database
		  eventdb = new SQLiteDatabase
		  
		  Dim f As new FolderItem
		  
		  
		  #If DebugBuild and TargetWin32
		    f = f.Parent
		  #endif
		  
		  //Pointing to database file
		  f = f.Child("database1.rsd")
		  
		  If f.Exists then
		    
		    EventDB.DatabaseFile = f
		    
		  else //File doesn't exist
		    
		    eventdb.DatabaseFile = f
		    
		    //Creating database file
		    Call eventdb.CreateDatabaseFile
		    
		    
		    If eventdb.Connect then
		      //Creating Events table
		      eventdb.SQLExecute("create table Events(ID integer, Start time, End time, Title text, Color text, Location text, Description text, Recurrence text)")
		      
		      'eventdb.SQLExecute("create table Repeat(ID integer, freq_type integer, freq_interval integer, freq_sub_interval integer, freq_relative_interval integer)")
		      eventdb.Commit
		      
		    else
		      MsgBox("db not created")
		    End If
		    
		  End If
		  
		  
		  'Call CalendarView.Register(
		End Sub
	#tag EndEvent

	#tag Event
		Function UnhandledException(error As RuntimeException) As Boolean
		  MsgBox Join(error.Stack, EndOfLine)
		  
		  Return True
		End Function
	#tag EndEvent


	#tag Constant, Name = kEditClear, Type = String, Dynamic = False, Default = \"Effacer", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"Effacer"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"Effacer"
	#tag EndConstant

	#tag Constant, Name = kFileQuit, Type = String, Dynamic = False, Default = \"Quitter", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"&Quitter"
	#tag EndConstant

	#tag Constant, Name = kFileQuitShortcut, Type = String, Dynamic = False, Default = \"", Scope = Public
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Cmd+Q"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"Ctrl+Q"
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
