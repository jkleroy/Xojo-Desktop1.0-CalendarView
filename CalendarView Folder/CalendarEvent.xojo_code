#tag Class
Protected Class CalendarEvent
	#tag Method, Flags = &h0
		Function Clone() As CalendarEvent
		  Dim C As New CalendarEvent(Title, New DateTime(StartDate), New DateTime(EndDate), _
		  EventColor, Location, Description, ID, Editable, Tag, Recurrence)
		  
		  If Recurrence <> Nil and RecurrenceParent is Nil then
		    C.RecurrenceParent = New WeakRef(self)
		  End If
		  
		  Return C
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  
		  Visible = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Title As String, StartDate As DateTime, EndDate As DateTime = Nil, EventColor As Color = &c4986E7, Location As String = "", Description As String = "", ID As String = "", Editable As Boolean = False, Tag As Variant = Nil, Recurrence As CalendarRecurrence = Nil)
		  self.Title = Title
		  self.StartDate = New DateTime(StartDate)
		  //self.StartDate.SecondsFrom1970 = StartDate.SecondsFrom1970
		  If EndDate <> Nil then
		    self.EndDate = New DateTime(EndDate)
		    //self.EndDate.SecondsFrom1970 = EndDate.SecondsFrom1970
		  else
		    self.EndDate = New DateTime(StartDate)
		    If StartDate.Hour <> 0 or StartDate.Minute <> 0 or StartDate.Second <> 0 then
		      //self.EndDate.Hour = self.EndDate.Hour + 1
		      Self.EndDate = Self.EndDate + New DateInterval(0,0,0,1)
		    End If
		  End If
		  self.EventColor = EventColor
		  Self.Location = Location
		  Self.Description = Description
		  self.ID = ID
		  self.Editable = Editable
		  self.Tag = Tag
		  self.Recurrence = Recurrence
		  
		  Visible = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DrawHTML(Index As Integer, ControlID As String) As String
		  
		  Dim Data() As String
		  
		  Data.Add "<td>"
		  
		  Data.Add "<div class=""ca-evp" + str(Index) + """ style=""color:" + FormatColor(EventColor) + """ " + _
		  "onclick=""Xojo.triggerServerEvent('" + ControlID + "','EventClicked',[this.getAttribute['class']]); return false;"">"
		  Data.Add "<span class=""te-t"">" + StartDate.ToString(DateTime.FormatStyles.None, DateTime.FormatStyles.Short) + "&nbsp;</span>"
		  Data.Add "<span class=""te-s"">" + Title + "</span>"
		  Data.Add "</div>"
		  
		  Data.Add "</td>"
		  
		  Return String.FromArray(Data,EndOfLine.UNIX)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FormatColor(c As color) As String
		  If c = &c0 then
		    
		    Return "#000000"
		  End If
		  
		  Dim R, G, B As String
		  
		  
		  R = Hex(c.Red)
		  G = Hex(c.Green)
		  B = Hex(c.Blue)
		  
		  If R.Length = 1 then
		    R = "0" + R
		  End If
		  If G.Length = 1 then
		    G = "0" + G
		  End If
		  If B.Length = 1 then
		    B = "0" + B
		  End If
		  
		  
		  Return "#" + R + G +B
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Compare(cevent As CalendarEvent) As Integer
		  //#ignore in LR
		  
		  If cevent is Nil then
		    Return 1
		  End If
		  
		  
		  If StartDate is Nil and cevent.StartDate is Nil then
		    Return 0
		  ElseIf cevent.StartDate is Nil then
		    Return 1
		  Elseif StartDate is Nil and cevent.StartDate <> Nil then
		    Return -1
		  End If
		  
		  If self.FrontMost and cevent.FrontMost then
		    'Break
		    //nothing
		  elseif self.FrontMost then
		    If StartDate.SQLDate = cevent.StartDate.SQLDate then
		      Return 1
		    End If
		  elseif cevent.FrontMost then
		    If StartDate.SQLDate = cevent.StartDate.SQLDate then
		      Return -1
		    End If
		  End If
		  
		  Dim b As Boolean
		  If self.FrontMost or cevent.FrontMost then
		    b = True
		  End If
		  
		  If StartDate < cevent.StartDate then Return -1
		  If StartDate > cevent.StartDate then Return 1
		  If StartDate = cevent.StartDate then
		    If Length > cevent.Length then Return -1
		    If Length = cevent.Length then Return 0
		    if Length < cevent.Length then Return 1
		  End If
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setDate(D As DateTime, setEndDate As Boolean = False)
		  If setEndDate then
		    'EndDate.Year = D.Year
		    'EndDate.Month = D.Month
		    'EndDate.Day = D.Day
		    EndDate = New DateTime(D.Year, d.Month, d.Day)
		    
		  else
		    
		    'StartDate.Year = D.Year
		    'StartDate.Month = D.Month
		    'StartDate.Day = D.Day
		    StartDate = New DateTime(D.Year, d.Month, d.Day)
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetLength(Value As Double)
		  //Set the length (in seconds) of the CalendarEvent
		  //
		  //This code will set the length of the Event to 2 hours
		  //<source>
		  //me.SetLength(2*60*60)
		  //</source>
		  
		  'EndDate = New Date(StartDate)
		  'EndDate.SecondsFrom1970 = EndDate.SecondsFrom1970 + Value
		  
		  EndDate = StartDate + New DateInterval(0,0,0,0,0,Value)
		End Sub
	#tag EndMethod


	#tag Note, Name = Description
		Class holder for all events displayed in the CalendarView.
		
	#tag EndNote

	#tag Note, Name = See Also
		CalendarView
		
	#tag EndNote


	#tag Property, Flags = &h0
		#tag Note
			This is used to store a buffer of the drawn event.
			This increases drawing performance.
		#tag EndNote
		Buffer As Picture
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			Day of month on which the CalendarEvent starts.
		#tag EndNote
		#tag Getter
			Get
			  return StartDate.Day
			End Get
		#tag EndGetter
		Day As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		#tag Note
			If True the CalendarEvent is a whole day event.
		#tag EndNote
		DayEvent As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Description of the CalendarEvent
		#tag EndNote
		Description As String
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Drawing Height of the CalendarEvent
		#tag EndNote
		DrawH As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Drawing Width of the CalendarEvent
		#tag EndNote
		DrawW As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Left drawing position of the CalendarEvent.
		#tag EndNote
		DrawX As Single
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Top drawing position of the CalendarEvent.
		#tag EndNote
		DrawY As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			newinversion 1.2.0
			If True, the event can be edited: dragged in the Calendar and length can be changed.
			
			When creating an event directly in the Calendar, Editable is true by default.
			When creating an event by code, Editable is false by default.
		#tag EndNote
		Editable As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			End date of the CalendarEvent.
		#tag EndNote
		EndDate As DateTime
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			Returns the EndDate.SecondsFrom1970.
		#tag EndNote
		#tag Getter
			Get
			  return EndDate.SecondsFrom1970
			End Get
		#tag EndGetter
		EndSeconds As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  If EndDate <> Nil then Return EndDate.SQLDateTime
			End Get
		#tag EndGetter
		Private EndSQLDate As String
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		#tag Note
			Color of the CalendarEvent.
		#tag EndNote
		EventColor As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			This property is used when dragging and creating the CalendarEvent.
			If True, the CalendarEvent is drawn over all others.
		#tag EndNote
		FrontMost As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Use this property if you need to link the CalendarEvent with a Database record.
		#tag EndNote
		ID As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			Length in seconds of the CalendarEvent.
		#tag EndNote
		#tag Getter
			Get
			  If StartDate is Nil then Return -1
			  If EndDate is Nil then
			    EndDate = New DateTime(StartDate)
			    'EndDate.SecondsFrom1970 = StartDate.SecondsFrom1970
			  End If
			  
			  return EndDate.SecondsFrom1970 - StartDate.SecondsFrom1970
			End Get
		#tag EndGetter
		Length As Double
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		#tag Note
			Location the CalendarEvent takes place in.
		#tag EndNote
		Location As String
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			If true, the mouse is over the CalendarEvent.
		#tag EndNote
		MouseOver As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Work in progress.
		#tag EndNote
		Recurrence As CalendarRecurrence
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Not used for the moment.
		#tag EndNote
		RecurrenceParent As WeakRef
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			StartDate of the CalendarEvent.
		#tag EndNote
		StartDate As DateTime
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			Returns the StartDate.SecondsFrom1970
		#tag EndNote
		#tag Getter
			Get
			  return StartDate.SecondsFrom1970
			End Get
		#tag EndGetter
		StartSeconds As Double
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  If StartDate <> Nil then Return StartDate.SQLDateTime
			End Get
		#tag EndGetter
		Private StartSQLDate As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			Returns the amount of seconds elapsed between Midnight and the time the CalendarEvent starts at.
		#tag EndNote
		#tag Getter
			Get
			  return StartDate.Hour * 3600 + StartDate.Minute * 60 + StartDate.Second
			End Get
		#tag EndGetter
		StartTime As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		#tag Note
			newinversion 1.2.2
			A “hidden” value associated with the CalendarEvent.
		#tag EndNote
		Tag As Variant
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Title of the CalendarEvent.
		#tag EndNote
		Title As String
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			If True, the CalendarEvent is visible in the CalendarView.
		#tag EndNote
		Visible As Boolean
	#tag EndProperty


	#tag Constant, Name = kVersion, Type = String, Dynamic = False, Default = \"1.3.0", Scope = Public
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
			Name="Length"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Description"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EventColor"
			Visible=false
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Title"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
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
			Name="Day"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Location"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DrawX"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Single"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StartSeconds"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="EndSeconds"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FrontMost"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DrawY"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DrawW"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DrawH"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MouseOver"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StartTime"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DayEvent"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Editable"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Buffer"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
