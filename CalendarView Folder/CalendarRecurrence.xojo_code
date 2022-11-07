#tag Class
Protected Class CalendarRecurrence
	#tag Method, Flags = &h1
		Protected Sub CalcEndAmountDate(cEvent As CalendarEvent)
		  
		  If EndAmount = 0 then Return
		  EndAmountDate = New Date(cEvent.StartDate)
		  
		  Dim idx As Integer = 1
		  
		  Select Case RepeatType
		    
		  Case TypeDaily
		    
		    //Adding the amount of Days including the Interval
		    EndAmountDate.TotalSeconds = EndAmountDate.TotalSeconds + 3600*24*(EndAmount-1)*Repeat_Recurrence_Factor
		    
		  Case TypeWeekDay
		    Dim tmpDate As New Date(EndAmountDate)
		    
		    
		    
		    While idx < EndAmount
		      tmpDate.Day = tmpDate.Day + 1
		      If tmpDate.DayOfWeek > 1 and tmpDate.DayOfWeek < 7 then
		        idx = idx + 1
		      End If
		      
		    Wend
		    
		    EndAmountDate = tmpDate
		    
		  Case TypeWeekly
		    
		    Dim tmpDate As New Date(EndAmountDate)
		    Dim weekNbr As Integer = EndAmountDate.WeekOfYear
		    Dim Interval As Integer
		    
		    tmpDate.Day = tmpDate.Day + 1
		    
		    If tmpDate.WeekOfYear <> weekNbr and Repeat_Recurrence_Factor > 1 then
		      tmpDate.TotalSeconds = tmpDate.TotalSeconds + 3600*24*7*Repeat_Recurrence_Factor
		      weekNbr = tmpDate.WeekOfYear
		    End If
		    
		    //Prevent a crash
		    If RepeatInterval = 0 then
		      RepeatInterval = 2^(cEvent.StartDate.DayOfWeek-1)
		    End If
		    
		    While idx < EndAmount
		      Interval = RepeatInterval
		      If Interval >= Interval8Saturday then
		        Interval = Interval mod Interval8Saturday
		        If tmpDate.DayOfWeek = 7 then
		          idx = idx + 1
		        End If
		      End If
		      If Interval >= Interval8Friday then
		        Interval = Interval mod Interval8Friday
		        If tmpDate.DayOfWeek = 6 then
		          idx = idx + 1
		        End If
		      End If
		      If Interval >= Interval8Thursday then
		        Interval = Interval mod Interval8Thursday
		        If tmpDate.DayOfWeek = 5 then
		          idx = idx + 1
		        End If
		      End If
		      If Interval >= Interval8Wednesday then
		        Interval = Interval mod Interval8Wednesday
		        If tmpDate.DayOfWeek = 4 then
		          idx = idx + 1
		        End If
		      End If
		      If Interval >= Interval8Tuesday then
		        Interval = Interval mod Interval8Tuesday
		        If tmpDate.DayOfWeek = 3 then
		          idx = idx + 1
		        End If
		      End If
		      If Interval >= Interval8Monday then
		        Interval = Interval mod Interval8Monday
		        If tmpDate.DayOfWeek = 2 then
		          idx = idx + 1
		        End If
		      End If
		      If Interval >= Interval8Sunday then
		        Interval = Interval mod Interval8Sunday
		        If tmpDate.DayOfWeek = 1 then
		          idx = idx + 1
		        End If
		      End If
		      
		      tmpDate.Day = tmpDate.Day + 1
		      
		      
		      If tmpDate.WeekOfYear <> weekNbr and Repeat_Recurrence_Factor > 1 then
		        tmpDate.TotalSeconds = tmpDate.TotalSeconds + 3600*24*7*(Repeat_Recurrence_Factor-1)
		        weekNbr = tmpDate.WeekOfYear
		      End If
		    Wend
		    
		    
		    EndAmountDate = tmpDate
		    
		  Case TypeMonthly
		    
		    Dim tmpDate As New Date(EndAmountDate)
		    
		    While idx < EndAmount
		      tmpDate.Day = 1
		      tmpDate.Month = tmpDate.Month + Repeat_Recurrence_Factor
		      tmpDate.Day = EndAmountDate.Day
		      If tmpDate.Day = EndAmountDate.Day then
		        idx = idx + 1
		      End If
		    Wend
		    
		    EndAmountDate = tmpDate
		    
		  Case TypeMonthlyRelative
		    
		    Dim tmpDate As New Date(EndAmountDate)
		    Dim Relative As Integer
		    Dim CurrMonth As Integer
		    Dim CalcDate As Date
		    
		    //Prevent a crash
		    If RepeatInterval = 0 then
		      RepeatInterval = cEvent.StartDate.DayOfWeek
		    End If
		    
		    While idx < EndAmount
		      tmpDate.Day = 1
		      tmpDate.Month = tmpDate.Month + Repeat_Recurrence_Factor
		      CurrMonth = tmpDate.Month
		      Relative = 0
		      
		      
		      While tmpDate.Month = CurrMonth
		        If tmpDate.DayOfWeek = RepeatInterval then
		          If Relative = 0 then
		            Relative = RelativeFirst
		          Elseif Relative = RelativeFirst then
		            Relative = RelativeSecond
		          Elseif Relative = RelativeSecond then
		            Relative = RelativeThird
		          Elseif Relative = RelativeThird then
		            Relative = RelativeFourth
		          Elseif Relative = RelativeFourth then
		            Relative = RelativeLast
		          End If
		          
		          If Repeat_Relative_Interval = Relative then
		            idx = idx + 1
		            Exit While
		          Elseif Repeat_Relative_Interval = RelativeLast and Relative = RelativeFourth then
		            CalcDate = New Date(tmpDate)
		            CalcDate.Day = CalcDate.Day+7
		            If CalcDate.Month <> tmpDate.Month then
		              //tmpDate is the last of the month
		              idx = idx + 1
		              Exit While
		            End If
		          End If
		          
		          'If Repeat_Recurrence_Factor = Relative then
		          'idx = idx + 1
		          'Exit While
		          'Elseif Repeat_Recurrence_Factor = RelativeLast and Relative = RelativeFourth then
		          'CalcDate = New Date(tmpDate)
		          'CalcDate.Day = CalcDate.Day+7
		          'If CalcDate.Month <> tmpDate.Month then
		          '//tmpDate is the last of the month
		          'idx = idx + 1
		          'Exit While
		          'End If
		          'End If
		        End If
		        
		        tmpDate.Day = tmpDate.Day + 1
		      Wend
		      
		      
		    Wend
		    
		    EndAmountDate = tmpDate
		    
		    
		    
		  Case TypeYearly
		    Dim tmpDate As New Date(EndAmountDate)
		    
		    While idx < EndAmount
		      tmpDate.Day = 1
		      tmpDate.Year = tmpDate.Year + Repeat_Recurrence_Factor
		      tmpDate.Month = EndAmountDate.Month
		      tmpDate.Day = EndAmountDate.Day
		      If tmpDate.Day = EndAmountDate.Day then
		        idx = idx + 1
		      End If
		    Wend
		    
		    EndAmountDate = tmpDate
		     
		  End Select
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(ICS As String)
		  If ICS.InStr("byday=byday")>0 then
		    ICS = ICS.ReplaceAll("byday=byday", "byday")
		  End If
		  
		  Dim Freq As String = ICS.NthField("FREQ=", 2).NthField(";", 1)
		  Dim ByDay As String = ICS.NthField("BYDAY=", 2).NthField(";", 1)
		  Dim ByMonthDay As String = ICS.NthField("BYMONTHDAY=", 2).NthField(";", 1)
		  Dim Interval As Integer = max(1, val(ICS.NthField("INTERVAL=", 2).NthField(";", 1)))
		  
		  
		  Select Case Freq
		    
		  Case "DAILY"
		    
		    RepeatType = TypeDaily
		    Repeat_Recurrence_Factor = Interval
		    
		  Case "WEEKLY"
		    
		    If ICS.InStr("FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR")>0 and Interval = 1 then
		      RepeatType = TypeWeekDay
		      
		    Else
		      RepeatType = TypeWeekly
		      Repeat_Recurrence_Factor = Interval
		      
		      //Each day
		      If ByDay <> "" then
		        If ByDay.InStr("MO")>0 then
		          RepeatInterval = RepeatInterval + Interval8Monday
		        End If
		        If ByDay.InStr("TU")>0 then
		          RepeatInterval = RepeatInterval + Interval8Tuesday
		        End If
		        If ByDay.InStr("WE")>0 then
		          RepeatInterval = RepeatInterval + Interval8Wednesday
		        End If
		        If ByDay.InStr("TH")>0 then
		          RepeatInterval = RepeatInterval + Interval8Thursday
		        End If
		        If ByDay.InStr("FR")>0 then
		          RepeatInterval = RepeatInterval + Interval8Friday
		        End If
		        If ByDay.InStr("SA")>0 then
		          RepeatInterval = RepeatInterval + Interval8Saturday
		        End If
		        If ByDay.InStr("SU")>0 then
		          RepeatInterval = RepeatInterval + Interval8Sunday
		        End If
		      Else
		        //Possible crash here
		        System.DebugLog "Possible Crash, BYDAY is empty"
		      End If
		      
		    End If
		    
		  Case "MONTHLY"
		    
		    If ByMonthDay <> "" then
		      RepeatType = TypeMonthly
		      Repeat_Recurrence_Factor = Interval
		      
		    Elseif ByDay <> "" then
		      
		      RepeatType = TypeMonthlyRelative
		      Repeat_Recurrence_Factor = Interval
		      Select case val(ByDay)
		      Case 1
		        Repeat_Relative_Interval = RelativeFirst
		      Case 2
		        Repeat_Relative_Interval = RelativeSecond
		      Case 3
		        Repeat_Relative_Interval = RelativeThird
		      Case 4
		        Repeat_Relative_Interval = RelativeFourth
		      Case -1
		        Repeat_Relative_Interval = RelativeLast
		      Else
		        //Exception
		        ByDay = ByDay
		      End Select
		      
		    End If
		    
		  Case "YEARLY"
		    
		    RepeatType = TypeYearly
		    Repeat_Recurrence_Factor = Interval
		    
		  End Select
		  
		  If ICS.InStr("UNTIL")>0 then
		    EndDate = New Date(VDate2SQLDate(ICS.NthField("UNTIL=", 2).NthField(";", 1)))
		    
		  Elseif ICS.InStr("COUNT")>0 then
		    EndAmount = val(ICS.NthField("COUNT=", 2).NthField(";", 1))
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CreateRecurrence(DisplayDate As Date, cEvent As CalendarEvent, ByRef ExitLoop As Boolean) As Boolean
		  
		  //End Date
		  If EndDate <> Nil then
		    If DisplayDate.SQLDate > EndDate.SQLDate then
		      ExitLoop = True
		      Return False
		    Elseif DisplayDate.SQLDate = EndDate.SQLDate and _
		      DisplayDate.TotalSeconds + cEvent.StartDate.Hour*3600 + cEvent.StartDate.Minute*60 + cEvent.StartDate.Second > EndDate.TotalSeconds then
		      ExitLoop = True
		      Return False
		    End If
		  End If
		  
		  //End Amount
		  If EndAmount > 0 then
		    If EndAmountDate is Nil then
		      CalcEndAmountDate(cEvent)
		    End If
		    If DisplayDate.SQLDate > EndAmountDate.SQLDate then
		      ExitLoop = True
		      Return False
		    End If
		  End If
		  
		  If lastOK <> Nil and lastOK.TotalSeconds > DisplayDate.TotalSeconds then
		    lastOK = Nil
		  End If
		  
		  Dim tmpDate As Date
		  If lastOK is Nil then
		    tmpDate = New Date(cEvent.StartDate)
		  Else
		    tmpDate = New Date(lastOK)
		  End If
		  
		  Select Case RepeatType
		    
		  Case TypeDaily
		    If Repeat_Recurrence_Factor = 1 then Return True
		    
		    While tmpDate.TotalSeconds < DisplayDate.TotalSeconds
		      tmpDate.Day = tmpDate.Day + Repeat_Recurrence_Factor
		    Wend
		    
		    If tmpDate.Day = DisplayDate.Day then
		      lastOK = new Date(DisplayDate)
		      Return True
		    End If
		    
		    
		  Case TypeWeekDay
		    If DisplayDate.DayOfWeek > 1 and DisplayDate.DayOfWeek < 7 then Return True
		    
		    
		  Case TypeWeekly
		    Dim Interval As Integer
		    Dim weekNbr As Integer = tmpDate.WeekOfYear
		    Dim OkToSearch As Boolean
		    
		    //Prevent a crash
		    If RepeatInterval = 0 then
		      RepeatInterval = 2^(cEvent.StartDate.DayOfWeek-1)
		    End If
		    
		    Interval = RepeatInterval
		    If Interval >= Interval8Saturday then
		      Interval = Interval mod Interval8Saturday
		      If DisplayDate.DayOfWeek = 7 then
		        OkToSearch = True
		      End If
		    End If
		    If Interval >= Interval8Friday then
		      Interval = Interval mod Interval8Friday
		      If DisplayDate.DayOfWeek = 6 then
		        OkToSearch = True
		      End If
		    End If
		    If Interval >= Interval8Thursday then
		      Interval = Interval mod Interval8Thursday
		      If DisplayDate.DayOfWeek = 5 then
		        OkToSearch = True
		      End If
		    End If
		    If Interval >= Interval8Wednesday then
		      Interval = Interval mod Interval8Wednesday
		      If DisplayDate.DayOfWeek = 4 then
		        OkToSearch = True
		      End If
		    End If
		    If Interval >= Interval8Tuesday then
		      Interval = Interval mod Interval8Tuesday
		      If DisplayDate.DayOfWeek = 3 then
		        OkToSearch = True
		      End If
		    End If
		    If Interval >= Interval8Monday then
		      Interval = Interval mod Interval8Monday
		      If DisplayDate.DayOfWeek = 2 then
		        OkToSearch = True
		      End If
		    End If
		    If Interval >= Interval8Sunday then
		      Interval = Interval mod Interval8Sunday
		      If DisplayDate.DayOfWeek = 1 then
		        OkToSearch = True
		      End If
		    End If
		    
		    If not OkToSearch then Return False
		    If Repeat_Recurrence_Factor = 1 then Return True
		    
		    While tmpDate.SQLDate < DisplayDate.SQLDate
		      tmpDate.Day = tmpDate.Day + 1
		       // a corriger
		      If tmpDate.WeekOfYear <> weekNbr and Repeat_Recurrence_Factor > 1 then
		        tmpDate.TotalSeconds = tmpDate.TotalSeconds + 3600*24*7*(Repeat_Recurrence_Factor-1)
		        weekNbr = tmpDate.WeekOfYear
		      End If
		    Wend
		    
		    If tmpDate.WeekOfYear = DisplayDate.WeekOfYear then
		      lastOK = new Date(DisplayDate)
		      Return True
		    End If
		    
		  Case TypeMonthly
		    
		    If Repeat_Recurrence_Factor = 1 and DisplayDate.Day = tmpDate.Day then
		      lastOK = New Date(DisplayDate)
		      Return True
		    End If
		    
		    While tmpDate.SQLDate < DisplayDate.SQLDate
		      tmpDate.Day = 1
		      tmpDate.Month = tmpDate.Month + Repeat_Recurrence_Factor
		      tmpDate.Day = cEvent.StartDate.Day
		    Wend
		    
		    If tmpDate.SQLDate = DisplayDate.SQLDate and tmpDate.Day = cEvent.StartDate.Day then
		      lastOK = new Date(DisplayDate)
		      Return True
		    End If
		    
		  Case TypeMonthlyRelative
		    
		    Dim Relative As Integer
		    #if DebugBuild
		      Dim CurrMonth As Integer
		      CurrMonth = tmpDate.Month
		    #endif
		    Dim CalcDate As Date
		    
		    //Prevent a crash
		    If RepeatInterval = 0 then
		      RepeatInterval = cEvent.StartDate.DayOfWeek
		    End If
		    
		    If DisplayDate.DayOfWeek <> RepeatInterval then Return False
		    
		    tmpDate.Day = 1
		    
		    While tmpDate.SQLDate <= DisplayDate.SQLDate
		      
		      If tmpDate.Month = DisplayDate.Month and tmpDate.Year = DisplayDate.Year then
		        
		        If tmpDate.DayOfWeek = RepeatInterval then
		          If Relative = 0 then
		            Relative = RelativeFirst
		          Elseif Relative = RelativeFirst then
		            Relative = RelativeSecond
		          Elseif Relative = RelativeSecond then
		            Relative = RelativeThird
		          Elseif Relative = RelativeThird then
		            Relative = RelativeFourth
		          Elseif Relative = RelativeFourth then
		            Relative = RelativeLast
		          End If
		          
		          If Repeat_Relative_Interval = Relative then
		            If tmpDate.SQLDate = DisplayDate.SQLDate then
		              lastOK = New Date(tmpDate)
		              Return True
		            Else
		              Return False
		            End If
		            
		          Elseif Repeat_Relative_Interval = RelativeLast and Relative = RelativeFourth then
		            CalcDate = New Date(tmpDate)
		            CalcDate.Day = CalcDate.Day+7
		            If CalcDate.Month <> tmpDate.Month then
		              //tmpDate is the last of the month
		              lastOK = New Date(tmpDate)
		              Return True
		            End If
		          End If
		        End If
		        
		        tmpDate.Day = tmpDate.Day + 1
		        
		      Elseif tmpDate.Month <> DisplayDate.Month or tmpDate.Year < DisplayDate.Year then
		        
		        If tmpDate.Month <> DisplayDate.Month and tmpDate.Year < DisplayDate.Year then
		          While tmpDate.Month <> DisplayDate.Month and tmpDate.Year < DisplayDate.Year
		            tmpDate.Day = 1
		            tmpDate.Month = tmpDate.Month + Repeat_Recurrence_Factor
		          Wend
		        Else
		          tmpDate.Day = 1
		          tmpDate.Month = tmpDate.Month + Repeat_Recurrence_Factor
		        End If
		        
		      else
		        tmpDate.Day = tmpDate.Day + 1
		        
		      End If
		    Wend
		    
		  Case TypeYearly
		    
		    While tmpDate.SQLDate < DisplayDate.SQLDate
		      tmpDate.Day = 1
		      tmpDate.Year = tmpDate.Year + Repeat_Recurrence_Factor
		      tmpDate.Month = cEvent.StartDate.Month
		      tmpDate.Day = cEvent.StartDate.Day
		    Wend
		    
		    If tmpDate.SQLDate = DisplayDate.SQLDate and tmpDate.Day = cEvent.StartDate.Day then
		      lastOK = new Date(DisplayDate)
		      Return True
		    End If
		    
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToICS(cEvent As CalendarEvent) As String
		  Dim txt() As String
		  Dim Days() As String = Array("", "SU", "MO", "TU", "WE", "TH", "FR", "SA")
		  
		  Select Case RepeatType
		    
		  Case TypeDaily
		    
		    txt.Append "FREQ=DAILY"
		    If Repeat_Recurrence_Factor > 1 then
		      txt.Append "INTERVAL=" + str(Repeat_Recurrence_Factor)
		    End If
		    
		  Case TypeWeekDay
		    
		    txt.Append "FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR"
		    
		  Case TypeWeekly
		    
		    txt.Append "FREQ=WEEKLY"
		    
		    If Repeat_Recurrence_Factor > 1 then
		      txt.Append "INTERVAL=" + str(Repeat_Recurrence_Factor)
		    End If
		    
		    Dim Interval As Integer
		    Dim ByDay() As String
		    Interval = RepeatInterval
		    If Interval >= Interval8Saturday then
		      Interval = Interval mod Interval8Saturday
		      ByDay.Append "SA"
		    End If
		    If Interval >= Interval8Friday then
		      Interval = Interval mod Interval8Friday
		      ByDay.Append "FR"
		    End If
		    If Interval >= Interval8Thursday then
		      Interval = Interval mod Interval8Thursday
		      ByDay.Append "TH"
		    End If
		    If Interval >= Interval8Wednesday then
		      Interval = Interval mod Interval8Wednesday
		      ByDay.Append "WE"
		    End If
		    If Interval >= Interval8Tuesday then
		      Interval = Interval mod Interval8Tuesday
		      ByDay.Append "TU"
		    End If
		    If Interval >= Interval8Monday then
		      Interval = Interval mod Interval8Monday
		      ByDay.Append "MO"
		    End If
		    If Interval >= Interval8Sunday then
		      Interval = Interval mod Interval8Sunday
		      ByDay.Insert(0, "SU")
		    End If
		    
		    Dim tmp As String
		    For i as Integer = 0 to UBound(ByDay)/2
		      tmp = ByDay(i)
		      ByDay(i) = ByDay(ByDay.Ubound-i)
		      ByDay(ByDay.Ubound-i) = tmp
		    Next
		    
		    txt.Append "BYDAY=" + Join(ByDay, ",")
		    
		    
		  Case TypeMonthly
		    
		    txt.Append "FREQ=MONTHLY"
		    If Repeat_Recurrence_Factor > 1 then
		      txt.Append "INTERVAL=" + str(Repeat_Recurrence_Factor)
		    End If
		    txt.Append "BYMONTHDAY=" + str(cEvent.StartDate.Day)
		    
		  Case TypeMonthlyRelative
		    
		    txt.Append "FREQ=MONTHLY"
		    If Repeat_Recurrence_Factor > 1 then
		      txt.Append "INTERVAL=" + str(Repeat_Recurrence_Factor)
		    End If
		    
		    Dim tmp As String
		    
		    If Repeat_Relative_Interval = RelativeFirst then
		      tmp = "BYDAY=1"
		    Elseif Repeat_Relative_Interval = RelativeSecond then
		      tmp = "BYDAY=2"
		    Elseif Repeat_Relative_Interval = RelativeThird then
		      tmp = "BYDAY=3"
		    Elseif Repeat_Relative_Interval = RelativeFourth then
		      tmp = "BYDAY=4"
		    Elseif Repeat_Relative_Interval = RelativeLast then
		      tmp = "BYDAY=-1"
		    End If
		    
		    tmp = tmp + Days(cEvent.StartDate.DayOfWeek)
		    
		    txt.Append tmp
		    
		  Case TypeYearly
		    
		    txt.Append "FREQ=YEARLY"
		    If Repeat_Recurrence_Factor > 1 then
		      txt.Append "INTERVAL=" + str(Repeat_Recurrence_Factor)
		    End If
		    
		  End Select
		  
		  //End of recurring event
		  If EndDate <> Nil then
		    Dim Time As String
		    Time = EndDate.SQLDateTime.ReplaceAll("-", "").Replace(" ", "T").ReplaceAll(":", "")
		    If EndDate.GMTOffset = 0 then
		      Time = Time + "Z"
		    End If
		    txt.Append "UNTIL=" + Time
		    
		  Elseif EndAmount > 0 then
		    txt.Append "COUNT=" + str(EndAmount)
		  End If
		  
		  Return Join(txt, ";")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function VDate2SQLDate(VDate As String) As Date
		  
		  
		  Dim D As New Date
		  Dim GMTOffset As Integer = D.GMTOffset
		  If VDate.Right(1) = "Z" then
		    D.GMTOffset = 0
		  End If
		  
		  D.Hour = 0
		  D.Minute = 0
		  D.Second = 0
		  
		  D.Year = val(Left(VDate, 4))
		  D.Month = val(Mid(VDate, 5, 2))
		  D.Day = val(Mid(VDate, 7, 2))
		  
		  D.Hour = val(Mid(VDate, 10, 2))
		  D.Minute = val(Mid(VDate, 12, 2))
		  D.Second = val(Mid(VDate, 14, 2))
		  
		  D.GMTOffset = GMTOffset
		  
		  Return D
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		EndAmount As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected EndAmountDate As Date
	#tag EndProperty

	#tag Property, Flags = &h0
		EndDate As Date
	#tag EndProperty

	#tag Property, Flags = &h0
		ID As String
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			Used by CreateRecurrence to keep the last Date where the event was displayed.
			This speeds up the calculation by 99%
		#tag EndNote
		Private lastOK As Date
	#tag EndProperty

	#tag Property, Flags = &h0
		RepeatInterval As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		RepeatOption As String
	#tag EndProperty

	#tag Property, Flags = &h0
		RepeatType As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Number of weeks or months between the scheduled execution of a job. 
			Repeat_Recurrence_Factor is used only if RepeatType is 8, 16, or 32.
			
		#tag EndNote
		Repeat_Recurrence_Factor As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Repeat_Relative_Interval As Integer
	#tag EndProperty


	#tag Constant, Name = Interval8Friday, Type = Double, Dynamic = False, Default = \"32", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Interval8Monday, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Interval8Saturday, Type = Double, Dynamic = False, Default = \"64", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Interval8Sunday, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Interval8Thursday, Type = Double, Dynamic = False, Default = \"16", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Interval8Tuesday, Type = Double, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Interval8Wednesday, Type = Double, Dynamic = False, Default = \"8", Scope = Public
	#tag EndConstant

	#tag Constant, Name = RelativeFirst, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = RelativeFourth, Type = Double, Dynamic = False, Default = \"8", Scope = Public
	#tag EndConstant

	#tag Constant, Name = RelativeLast, Type = Double, Dynamic = False, Default = \"16", Scope = Public
	#tag EndConstant

	#tag Constant, Name = RelativeSecond, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = RelativeThird, Type = Double, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeDaily, Type = Double, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeMonthly, Type = Double, Dynamic = False, Default = \"16", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeMonthlyRelative, Type = Double, Dynamic = False, Default = \"32", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeWeekDay, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeWeekly, Type = Double, Dynamic = False, Default = \"8", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeYearly, Type = Double, Dynamic = False, Default = \"64", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EndAmount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RepeatType"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RepeatInterval"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RepeatOption"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Repeat_Relative_Interval"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Repeat_Recurrence_Factor"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
