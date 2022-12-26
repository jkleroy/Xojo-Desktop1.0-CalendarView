#tag Class
Protected Class CalendarYearPicker
	#tag Method, Flags = &h0
		Sub Constructor(strDecades As String = "Decades", strYears As String = "Years", strMonths As String = "Months")
		  DecadeOver = -1
		  YearOver = -1
		  MonthOver = -1
		  
		  self.strDecades = strDecades
		  self.strMonths = strMonths
		  self.strYears = strYears
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Draw(g As Graphics, owner As CalendarView)
		  Dim x,y As Integer
		  Dim DrawDate As DateTime
		  Dim i, idx As Integer
		  Dim startYear As Integer
		  Dim HeaderHeight As Integer = 39
		  Dim DeltaX, xx As Single
		  Dim xAmount As Integer
		  
		  Dim txt As String
		  
		  //Setting FirstDate
		  DrawDate = New DateTime(owner.FirstDate)
		  startYear = (DrawDate.Year-100)\10*10
		  
		  //------------------
		  //Drawing Background
		  If owner.MyStyle.FillGradient then
		    gradient(g, 0, g.Height, Owner.MyColors.PBackground, Owner.MyColors.PBackground2, True)
		  else
		    g.DrawingColor = Owner.MyColors.PBackground
		    g.FillRectangle(0, 0, g.Width, g.Height)
		  End If
		  
		  //-----------------
		  //Header Background
		  If owner.TransparentBackground then
		    Dim gh As Graphics = g.Clip(0, 0, g.Width, HeaderHeight)
		    DrawBackground(gh, owner)
		  else
		    g.DrawingColor = owner.MyColors.Header
		    If owner.StyleType = owner.StyleOutlook2013 then
		      g.FillRectangle(0, 0, g.Width, 22)
		    else
		      g.FillRectangle(0, 0, g.Width, HeaderHeight)
		    End If
		  End If
		  
		  
		  
		  y = g.TextHeight
		  
		  //------------------------
		  //Drawing Month at the top
		  g.DrawingColor = owner.MyColors.Title
		  g.Bold = True
		  txt = owner.MonthNames(DrawDate.Month) + " " + str(DrawDate.Year)
		  g.DrawText(txt, (g.Width-g.TextWidth(txt))\2, (22-g.TextHeight)\2 + g.FontAscent)
		  
		  
		  //----------------------- Decades -----------------------//
		  
		  //------------------
		  //Setting up Decades
		  y = 36
		  g.FontSize = owner.MyStyle.PTextSize
		  g.DrawingColor = Owner.MyColors.DayName
		  txt = strDecades
		  g.DrawText(txt, (g.Width-g.TextWidth(txt))\2, y)
		  
		  
		  y = y + g.FontAscent
		  g.FontSize = owner.MyStyle.PTextSize
		  g.Bold = Owner.MyStyle.PDayNumberbold
		  g.DrawingColor = owner.MyColors.PDayNumberActive
		  
		  xAmount = min(12, g.Width/g.TextWidth(str(DrawDate.Year)))
		  If xAmount*g.TextWidth(str(DrawDate.Year)) + (xAmount)*4 > g.Width then
		    xAmount = xAmount-1
		  End If
		  
		  If owner.Border then
		    'If owner.HiDPI then
		    'DeltaX = (g.Width-4)/xAmount
		    'x = 2
		    'else
		    DeltaX = (g.Width-2)/xAmount
		    x = 1
		    'End If
		  else
		    x = 0
		  End If
		  xx = x
		  idx = startYear
		  
		  //---------------
		  //Drawing Decades
		  for i = 1 to 12
		    
		    If Floor(DrawDate.Year/10)*10 = idx then
		      g.DrawingColor = owner.MyColors.PSelected
		      g.FillRectangle(xx, y-g.FontAscent+2, DeltaX, g.FontAscent)
		      g.DrawingColor = owner.MyColors.PDayNumberActive
		    End If
		    
		    txt = str(idx)
		    g.DrawText(txt, xx+(DeltaX - g.TextWidth(txt))/2, y)
		    
		    If i = 12 then //Exit if end of drawing to prevent going to next line
		      Exit for i
		    End If
		    
		    If i mod xAmount = 0 then
		      #if DebugBuild
		        Dim a As Integer
		        a = 12-i
		      #endif
		      If 12-i < xAmount then
		        x = (g.Width-DeltaX*(12-i))/2
		      End If
		      xx = x
		      y = y + g.FontAscent
		    else
		      xx = xx + DeltaX
		    End If
		    
		    idx = idx + 10
		  next
		  
		  //----------------------- Years -----------------------//
		  
		  //----------------
		  //Setting up Years
		  x = 0
		  y = y + g.TextHeight
		  If owner.StyleType <> owner.StyleOutlook2013 then
		    g.DrawingColor = owner.MyColors.Header
		    g.FillRectangle(0, y-g.FontAscent+2, g.Width, g.FontAscent)
		  End If
		  
		  g.DrawingColor = Owner.MyColors.DayName
		  txt = strYears
		  g.Bold = True
		  g.DrawText(txt, (g.Width-g.TextWidth(txt))\2, y)
		  y = y + g.FontAscent
		  
		  g.FontSize = owner.MyStyle.PTextSize
		  g.Bold = Owner.MyStyle.PDayNumberbold
		  g.DrawingColor = owner.MyColors.PDayNumberActive
		  
		  xAmount = min(10, g.Width/g.TextWidth("0"))
		  If xAmount*g.TextWidth("0") + (xAmount)*5 > g.Width then
		    xAmount = xAmount-1
		  End If
		  If xAmount < 10 and xAmount>5 then
		    xAmount = 5
		  End If
		  
		  If owner.Border then
		    'If owner.HiDPI then
		    'DeltaX = (g.Width-4)/xAmount
		    'x = 2
		    'else
		    DeltaX = (g.Width-2)/xAmount
		    x = 1
		    'End If
		  else
		    x = 0
		  End If
		  xx = x
		  
		  //-------------
		  //Drawing Years
		  For i = 0 to 9
		    txt = str(i)
		    If DrawDate.Year.ToString.Right(1) = txt then
		      g.DrawingColor = owner.MyColors.PSelected
		      g.FillRectangle(xx, y-g.FontAscent+2, DeltaX, g.FontAscent)
		      g.DrawingColor = owner.MyColors.PDayNumberActive
		    End If
		    
		    g.DrawText(txt, xx+(DeltaX - g.TextWidth(txt))/2, y)
		    
		    If (i+1) mod xAmount = 0 then
		      y = y + g.FontAscent
		      xx = x
		      
		    else
		      xx = xx + DeltaX
		    End If
		  Next
		  
		  //----------------------- Months -----------------------//
		  
		  //-----------------
		  //Setting up Months
		  
		  x = 0
		  y = y + g.TextHeight
		  If owner.StyleType <> owner.StyleOutlook2013 then
		    g.DrawingColor = owner.MyColors.Header
		    g.FillRectangle(0, y-g.FontAscent+2, g.Width, g.FontAscent)
		  End If
		  
		  txt = strMonths
		  g.Bold = True
		  g.DrawingColor = Owner.MyColors.DayName
		  g.DrawText(txt, (g.Width-g.TextWidth(txt))\2, y)
		  y = y + g.FontAscent
		  
		  g.FontSize = owner.MyStyle.PTextSize
		  g.Bold = Owner.MyStyle.PDayNumberbold
		  g.DrawingColor = owner.MyColors.PDayNumberActive
		  
		  xAmount = min(12, g.Width/g.TextWidth("12"))
		  If xAmount*g.TextWidth("12") + (xAmount)*4 > g.Width then
		    xAmount = xAmount-1
		  End If
		  If xAmount < 12 then
		    If xAmount >= 6 then
		      xAmount = 6
		    elseif xAmount = 5 then
		      xAmount = 4
		    End If
		  End If
		  
		  If owner.Border then
		    'If owner.HiDPI then
		    'DeltaX = (g.Width-4)/xAmount
		    'x = 2
		    'else
		    DeltaX = (g.Width-2)/xAmount
		    x = 1
		    'End If
		  else
		    x = 0
		  End If
		  xx = x
		  
		  //-------------
		  //Drawing Months
		  For i = 1 to 12
		    txt = str(i)
		    
		    If DrawDate.Month = i then
		      g.DrawingColor = owner.MyColors.PSelected
		      g.FillRectangle(xx, y-g.FontAscent+2, DeltaX, g.FontAscent)
		      g.DrawingColor = owner.MyColors.PDayNumberActive
		    End If
		    
		    g.DrawText(txt, xx+(DeltaX - g.TextWidth(txt))/2, y)
		    
		    If i mod xAmount = 0 then
		      y = y + g.FontAscent
		      xx = x
		      
		    else
		      xx = xx + DeltaX
		    End If
		    
		  Next
		  
		  
		  //--------------
		  //Drawing Border
		  If owner.Border then
		    g.DrawingColor = owner.MyColors.Border
		    If owner.TransparentBackground then
		      g.DrawRectangle(0, HeaderHeight, g.Width, g.Height-HeaderHeight)
		      'If owner.HiDPI then
		      'g.DrawRectangle(1, HeaderHeight+1, g.Width-2, g.Height-HeaderHeight-2)
		      'End If
		    else
		      g.DrawRectangle(0, 0, g.Width, g.Height)
		      'If owner.HiDPI then
		      'g.DrawRectangle(1, 1, g.Width-2, g.Height-2)
		      'End If
		    End If
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawBackground(g As Graphics, owner As CalendarView)
		  'If HasBackcolor then
		  'g.DrawingColor = Backcolor
		  'g.FillRectangle(0, 0, g.Width, g.Height)
		  '
		  'else
		  
		  g.DrawingColor = GetWindowColor(owner)
		  g.FillRectangle(0, 0, g.Width, g.Height)
		  
		  If owner.Window.Backdrop <> Nil then
		    Dim p As Picture = owner.Window.Backdrop
		    If owner.Left < p.Width and owner.Top < p.Height then
		      g.DrawPicture p, 0, 0, g.Width, g.Height, owner.left, owner.top, g.Width, g.Height
		    End If
		  End If
		  'End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetWindowColor(owner As CalendarView) As Color
		  #if RBVersion>2009 then
		    If Owner.Window.HasBackgroundColor then
		      Return Owner.Window.BackgroundColor
		  #else
		    If Owner.Window.HasBackColor then
		      Return Owner.Window.BackColor
		  #endif
		  Else
		    #if TargetMacOS
		      //A corriger?
		      Return &cEDEDED
		    #else
		      Return Color.FillColor()
		    #endif
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub gradient(g as graphics, start as integer, length as integer, startColor as color, endColor as color, Vertical As Boolean = True)
		  //modified gradient code, original code: Seth Willits
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  
		  dim i as integer, ratio, endratio as Single
		  
		  If length = 0 then
		    Return
		  End If
		  
		  // Draw the gradient
		  for i = start to start + length
		    
		    // Determine the current line's color
		    ratio = ((length-(i-start))/length)
		    
		    
		    endratio = ((i-start)/length)
		    g.DrawingColor = Color.RGB(EndColor.Red * endratio + StartColor.Red * ratio, EndColor.Green * endratio + StartColor.Green * ratio, EndColor.Blue * endratio + StartColor.Blue * ratio)
		    
		    // Draw the step
		    If Vertical then
		      g.DrawLine 0, i, g.Width, i
		      
		    Else
		      g.DrawLine i, 0, i, g.Height
		    End If
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseDown(x As Integer, y As Integer)
		  #Pragma Unused x
		  #Pragma Unused y
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MouseMove(X As Integer, Y As Integer)
		  #Pragma Unused X
		  #Pragma Unused Y
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h1
		Protected DecadeOver As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected MonthOver As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The text displayed for Decades
		#tag EndNote
		strDecades As String
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The text displayed for Years
		#tag EndNote
		strMonths As String
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The text displayed for Years
		#tag EndNote
		strYears As String
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected YearOver As Integer
	#tag EndProperty


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
			Name="strDecades"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="strYears"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="strMonths"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
