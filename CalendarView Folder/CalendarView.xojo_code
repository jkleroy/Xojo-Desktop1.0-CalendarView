#tag Class
Protected Class CalendarView
Inherits DesktopCanvas
	#tag Event
		Sub Closing()
		  //Thanks to Dr Michael Oeser for this update
		  
		  If RefreshTimer <> Nil then
		    RefreshTimer.RunMode = timer.RunModes.Off
		    #pragma BreakOnExceptions Off   // For debugging purposes
		    Try
		      RemoveHandler RefreshTimer.Action, addressof TimerAction
		    Catch err
		      // do nothing
		    End
		    #pragma BreakOnExceptions Default
		  End If
		  
		  RaiseEvent Close()
		End Sub
	#tag EndEvent

	#tag Event
		Function ConstructContextualMenu(base As DesktopMenuItem, x As Integer, y As Integer) As Boolean
		  Return ConstructContextualMenu(base, X, Y, EventForXY(X, Y))
		End Function
	#tag EndEvent

	#tag Event
		Sub Deactivated()
		  //
		End Sub
	#tag EndEvent

	#tag Event
		Sub DoublePressed(x As Integer, y As Integer)
		  
		  
		  'If not CreateWithDrag then Return
		  
		  //Edit event when double click
		  Dim E As CalendarEvent = EventForXY(X, Y, True)
		  Dim Idx As Integer
		  If E <> Nil and E.Visible and E.Editable then
		    E.Buffer = Nil
		    
		    Idx = Events.IndexOf(E)
		    Dim tmpEvent As CalendarEvent
		    tmpEvent = EditEvent(E)
		    If tmpEvent <> Nil then
		      If tmpEvent.RecurrenceParent <> Nil then
		        Dim ParentEvent As CalendarEvent = CalendarEvent(tmpEvent.RecurrenceParent.Value)
		        idx = Events.IndexOf(ParentEvent)
		        
		        If not EditOrDeleteRecurrentEvent(ParentEvent) then
		          Return
		        End If
		        
		        Dim length As Integer = tmpEvent.Length
		        
		        tmpEvent.setDate(ParentEvent.StartDate)
		        tmpEvent.SetLength(length)
		        tmpEvent.RecurrenceParent = Nil
		        
		        If Idx > -1 Then
		          Redim DisplayEvents(-1)
		        End If
		        
		      End If
		      
		      If Idx > -1 Then
		        Events.RemoveAt(Idx)
		        Events.AddAt(Idx, tmpEvent)
		        
		        #if TargetDesktop
		          FullRefresh = True
		          Refresh(False)
		        #elseif TargetWeb
		          Redisplay()
		        #endif
		      End If
		    End If
		    
		  else
		    If DoubleClick(X , Y) then Return
		    
		    if ViewType = TypeMonth then
		      Dim d As DateTime = DateForXY(X, Y)
		      
		      If d <> Nil then
		        DisplayDate = d
		        ViewType = TypeWeek
		      End If
		      
		    elseIf ViewType = TypeYear then
		      Dim d As DateTime = DateForXY(X, Y)
		      
		      If d <> Nil then
		        DisplayDate = d
		        ViewType = TypeMonth
		      End If
		      Return
		      
		    Elseif ViewType = TypePicker then
		      
		      If X > 10 and X < Width-10 and Y < 36 then
		        Dim d As DateTime = DateTime.Now
		        
		        Displaydate = d
		        Redisplay()
		      End If
		      Return
		    End If
		    
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Function DragEnter(obj As DragItem, action As DragItem.Types) As Boolean
		  //
		  #pragma Unused obj
		  #pragma Unused action
		End Function
	#tag EndEvent

	#tag Event
		Sub DragExit(obj As DragItem, action As DragItem.Types)
		  #pragma Unused obj
		  #pragma Unused action
		End Sub
	#tag EndEvent

	#tag Event
		Function DragOver(x As Integer, y As Integer, obj As DragItem, action As DragItem.Types) As Boolean
		  #pragma Unused x
		  #pragma Unused y
		  #pragma Unused obj
		  #pragma Unused action
		End Function
	#tag EndEvent

	#tag Event
		Sub DropObject(obj As DragItem, action As DragItem.Types)
		  #pragma Unused action
		  
		  DropObject = True
		  If obj.FolderItem <> Nil and obj.FolderItem.Exists then
		    
		    If obj.FolderItem.Name.Right(4) = ".ics" or obj.FolderItem.Name.Right(4) = ".vcs" then
		      
		      ImportICS(TextInputStream.Open(obj.FolderItem).ReadAll)
		      
		      
		      
		    End If
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Function KeyDown(key As String) As Boolean
		  
		  #if TargetWeb
		    
		    If Details.KeyCode = Details.KeyArrowLeft then
		      me.Scroll(-1)
		    Elseif Details.KeyCode = Details.KeyArrowRight then
		      me.Scroll(1)
		    End If
		    
		  #elseif TargetDesktop
		    If KeyDown(Key) then Return True
		    
		    
		    If key = chr(28) then
		      me.SCroll(-1)
		      
		    elseif key = chr(29) then
		      me.Scroll(1)
		      
		    End If
		    
		    If ViewType > TypeMonth then
		      
		      Dim deltaY As Integer
		      If key = chr(30) then
		        deltaY= -3
		      elseif key = chr(31) then
		        deltaY = 3
		      End If
		      ShowScrollBar = True
		      
		      Scroll(0, deltaY)
		      
		      ShowScrollBar = False
		      RefreshTimer.Period = 500
		    End If
		  #endif
		End Function
	#tag EndEvent

	#tag Event
		Sub KeyUp(key As String)
		  #pragma Unused key
		End Sub
	#tag EndEvent

	#tag Event
		Sub MenuBarSelected()
		  //
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  Return handleMouseDown(X, Y)
		End Function
	#tag EndEvent

	#tag Event
		Sub MouseDrag(x As Integer, y As Integer)
		  If MovingScrollBar or DragViewHeight then
		    
		  elseif not CreateWithDrag and DragEvent = 0 then
		    Return
		  elseif SelStart is Nil and DragEvent = 0 then
		    Return
		  Elseif ViewType = TypePicker then
		    Return
		  Elseif DragEvent = DragView then
		    Return
		  End If
		  
		  If UserCancelled or Keyboard.AsyncKeyDown( &h35 ) then
		    SelStart = Nil
		    SelEnd = Nil
		    FullRefresh = True
		    Redisplay
		    Return
		  End If
		  
		  If x = lastX and Y = lastY then Return
		  If Y > Height then
		    Return
		  End If
		  
		  If ViewType > TypeMonth and MovingScrollBar then
		    Dim lastScroll As Double = mScrollPosition
		    
		    ScrollPosition = max(0, min(24, ScrollPosition + (Y - lastY) / ((Height-ViewHeight-ScrollBarHeight)/24)))
		    
		    
		    lastX = X
		    lastY = Y
		    
		    If mScrollPosition <> lastScroll then
		      FullRefresh = True
		      Redisplay
		    End If
		    
		    Return
		    
		    
		    //Drag
		  elseif ViewType = TypeMonth and DragEvent = DragMove then
		    
		    Dim tmpDate As DateTime = DateForXY(X, Y)
		    If tmpDate <> Nil then
		      Dim length As Integer = LastMouseOver.Length
		      Dim lastStart As Double = LastMouseOver.StartSeconds
		      
		      'LastMouseOver.StartDate.SQLDate = tmpDate.SQLDate
		      LastMouseOver.StartDate = DateTime.FromString(tmpDate.SQLDate)
		      LastMouseOver.SetLength(length)
		      
		      If lastStart <> LastMouseOver.StartSeconds then
		        DragEvent(LastMouseOver)
		        Redisplay
		      End If
		    End If
		    
		    
		  elseif ViewType = TypeMonth then
		    
		    If SelEnd is Nil then
		      SelEnd = New DateTime(SelStart)
		      FullRefresh = True
		      Redisplay
		      Return
		    End If
		    
		    Dim tmpDate As DateTime = DateForXY(X, Y)
		    If tmpDate <> Nil then
		      
		      If tmpDate.SQLDate < SelStart.SQLDate then
		        If DragBack then
		          SelStart = tmpDate
		        else
		          DragBack = True
		          'SelEnd.SQLDate = SelStart.SQLDate
		          SelEnd = DateTime.FromString(SelStart.SQLDate)
		          'SelStart.SQLDate = tmpDate.SQLDate
		          SelStart = DateTime.FromString(tmpDate.SQLDate)
		        End If
		        
		      elseif DragBack and tmpDate.SQLDate > SelStart.SQLDate then
		        If tmpDate.SQLDate > SelEnd.SQLDate then
		          DragBack = False
		          'SelStart.SQLDate = SelEnd.SQLDate
		          SelStart = DateTime.FromString(SelEnd.SQLDate)
		          'SelEnd.SQLDate = tmpDate.SQLDate
		          SelEnd = DateTime.FromString(tmpDate.SQLDate)
		        else
		          SelStart = tmpDate
		        End If
		        
		      elseif not DragBack and tmpDate.SQLDate < SelEnd.SQLDate then
		        SelEnd = tmpDate
		        
		      elseif tmpDate.SQLDate = SelStart.SQLDate and tmpDate.SQLDate = SelEnd.SQLDate then
		        DragBack = False
		        Return
		        
		      elseif tmpDate.SQLDate > SelEnd.SQLDate then
		        DragBack = False
		        oktobreak = True
		        'SelEnd.SQLDate = tmpDate.SQLDate
		        SelEnd = DateTime.FromString(tmpDate.SQLDate)
		        
		      elseif tmpDate.SQLDate = SelEnd.SQLDate then
		        Return
		      elseif tmpDate.SQLDate = SelStart.SQLDate then
		        Return
		      End If
		      
		      FullRefresh = True
		      Redisplay
		    End If
		    
		  Elseif ViewType > TypeMonth and DragViewHeight then //Draging ViewHeight
		    
		    If DayEventsHeight = -1 then
		      DayEventsHeight = me.ViewHeight-HeaderHeight
		    End If
		    
		    If Y < HeaderHeight and DayEventsHeight = 0 then Return
		    If Y > Height\2 then Return
		    Dim LastDayEventsHeight As Integer = DayEventsHeight
		    
		    DayEventsHeight = max(0, min(DayEventsHeight + Y-lastY, Height\2))
		    
		    If DayEventsHeight <> LastDayEventsHeight then
		      FullRefresh = True
		      Redisplay
		    End If
		    
		    //Drag
		  Elseif ViewType > TypeMonth and DragEvent>0 then
		    
		    HandleDragEvent(X, Y)
		    
		  Elseif ViewType > TypeMonth then
		    
		    If SelEnd is Nil then
		      SelEnd = New DateTime(SelStart)
		      FullRefresh = True
		      Redisplay
		      Return
		    End If
		    
		    
		    Dim tmpDate As DateTime = DateForXY(X, Y)
		    If tmpDate <> Nil then
		      
		      If not DayEventClicked then
		        If Abs(Y-Height) > HourHeight \2 then
		          'tmpDate.SQLDate = SelStart.SQLDate
		          tmpDate = DateTime.FromString(SelStart.SQLDate)
		        End If
		      End If
		      
		      If tmpDate.SQLDateTime > SelEnd.SQLDateTime then
		        DragBack = False
		        SelEnd = tmpDate
		        
		      elseif tmpDate.SQLDateTime < SelStart.SQLDateTime then
		        DragBack = True
		        SelStart = tmpDate
		        
		      elseif DragBack and tmpDate.SQLDateTime > SelStart.SQLDateTime then
		        SelStart = tmpDate
		        
		      elseif not DragBack and tmpDate.SQLDateTime < SelEnd.SQLDateTime then
		        SelEnd = tmpDate
		        
		      elseif tmpDate >=SelStart and tmpDate <= SelEnd then
		        Return
		      End If
		      
		      FullRefresh = True
		      Redisplay
		    End If
		    
		  End If
		  
		  
		  
		  lastX = X
		  lastY = Y
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseEnter()
		  //
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseExit()
		  #if TargetDesktop
		    If ShowScrollBar then
		      ShowScrollBar = False
		      RefreshTimer.Period = 500
		    End If
		    
		    If me.MouseCursor <> System.Cursors.StandardPointer then
		      me.MouseCursor = System.Cursors.StandardPointer
		    End If
		  #endif
		  
		  If DragEvent = DragMove then
		    Return
		  End If
		  
		  If LastMouseOver <> Nil and LastMouseOver.MouseOver then
		    LastMouseOver.MouseOver = False
		    Redisplay()
		  End If
		  LastMouseOver = Nil
		  
		  If LastDayOver <>-1 then
		    LastDayOver = -1
		    Redisplay()
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseMove(x As Integer, y As Integer)
		  'Dim mp As new MethodProfiler(CurrentMethodName)
		  #if TargetDesktop
		    If AnimationInProgress <> 0 then
		      Return
		    End If
		    
		    Dim HideScrollBar As Boolean
		    
		    If ViewType = TypePicker then
		      
		      Dim LastOver As Integer = LastDayOver
		      Call DateForXY(X, Y)
		      If LastDayOver <> LastOver then
		        Redisplay()
		      End If
		      
		      
		    ElseIf ViewType > TypeMonth and X > Width - 8 then
		      If not ShowScrollBar then
		        FullRefresh = True
		        ShowScrollBar = True
		      End If
		      
		      
		    Elseif ViewType >= TypeMonth then
		      
		      If ShowScrollBar then
		        HideScrollBar = True
		      End If
		      
		      If ViewType > TypeMonth and Y > me.ViewHeight-3 and Y < me.ViewHeight+2 and not LockDayEventsHeight then
		        me.MouseCursor = System.Cursors.ArrowNorthSouth
		        
		      else
		        
		        Dim E As CalendarEvent = EventForXY(X, Y, True)
		        If (E is LastMouseOver) = False then
		          If DragEvents then
		            LastMouseOver = E
		          else
		            LastMouseOver = E
		          End If
		          If ViewType > TypeMonth then
		            FullRefresh = True
		          End If
		          Dim txt As String
		          If E <> Nil and E.Visible then
		            If MoreEventsDate <> Nil then
		              FullRefresh = True
		              MoreEventsDate = Nil
		            End If
		            
		            E.MouseOver = (Y > ViewHeight) And DragEvents
		            
		            //Setting new ToolTip
		            If ViewType >= TypeMonth then
		              If E.Length mod 86400 <> 0 then
		                txt = HelpTagFormat.ReplaceAll("%Start", E.StartDate.ToString(DateTime.FormatStyles.None, DateTime.FormatStyles.Short)).ReplaceAll("%End", E.EndDate.ToString(DateTime.FormatStyles.None, DateTime.FormatStyles.Short))
		                
		              Else
		                txt = HelpTagFormat.ReplaceAll("%Start", E.StartDate.ToString(DateTime.FormatStyles.Short, DateTime.FormatStyles.None)).ReplaceAll("%End", E.EndDate.ToString(DateTime.FormatStyles.Short, DateTime.FormatStyles.None))
		                
		              End If
		              
		              txt = txt.ReplaceAll("%Title", E.Title)
		              If txt.IndexOf("%Length")>0 then
		                txt = txt.Replace("%Length", str(Floor(E.Length/3600)) + ":" + Format(E.Length/60 - Floor(E.Length/3600) * 60, "00"))
		              End If
		              
		              txt = txt.ReplaceAll("%Location", E.Location).ReplaceAll("%Description", E.Description)
		              
		              
		            End If
		          Elseif E<>Nil and E.Visible = False and MoreEventsDate is Nil then
		            MoreEventsDate = DateForXY(X, Y)
		            FullRefresh = True
		          Elseif E is Nil and ViewType = TypeMonth then
		            If MoreEventsDate <> Nil then
		              FullRefresh = True
		              MoreEventsDate = Nil
		            End If
		            
		          End If
		          If ShowHelptag(txt, E) then
		            //ToolTip is handled directly in the event
		          else
		            If me.ToolTip <> txt then
		              me.ToolTip = txt
		            End If
		          End If
		          
		        Elseif E <> Nil and ViewType > TypeMonth then
		          
		          If DragEvents then
		            E.MouseOver = True
		            If Y> ViewHeight and Y >E.DrawY+E.DrawH - 6 and E.Editable then
		              
		              me.MouseCursor = System.Cursors.ArrowNorthSouth
		            elseif me.MouseCursor <> System.Cursors.StandardPointer then
		              me.MouseCursor = System.Cursors.StandardPointer
		            End If
		          End If
		          
		        Elseif me.MouseCursor <> System.Cursors.StandardPointer then
		          me.MouseCursor = System.Cursors.StandardPointer
		        End If
		        
		        
		      End If
		      
		    End If
		    
		    If FullRefresh then
		      Redisplay
		    End If
		    
		    If HideScrollBar then
		      ShowScrollBar = False
		      RefreshTimer.Period = 500
		    End If
		    
		  #Elseif TargetWeb
		    
		    Dim cEvent As CalendarEvent = me.EventForXY(X, Y)
		    
		    If cEvent <> Nil then
		      me.Cursor = System.WebCursors.FingerPointer
		    else
		      me.Cursor = System.WebCursors.StandardPointer
		    End If
		    
		    LastMouseOver = cEvent
		    
		  #endif
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseUp(x As Integer, y As Integer)
		  handleMouseUp(X, Y)
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseWheel(x As Integer, y As Integer, deltaX As Integer, deltaY As Integer) As Boolean
		  If MouseWheel(X, Y, deltaX, deltaY) then
		    Return True
		  End If
		  
		  //Requested by Koua
		  #if TargetMacOS then
		    deltaX = -deltaX
		  #endif
		  
		  If (ViewType = TypeMonth or ViewType = TypeYear or ViewType = TypePicker) and DisableScroll = False then
		    If deltaX <> 0 then
		      Scroll(-Abs(deltaX) / deltaX)
		    elseif deltaY <> 0 then
		      Scroll(Abs(deltaY) / deltaY)
		    End If
		    
		    
		  elseif ViewType > TypeMonth then
		    ShowScrollBar = True
		    
		    If DisableScroll then
		      DeltaX = 0
		    End If
		    
		    If DeltaX = 0 and DeltaY = 0 Then Return True
		    
		    If deltaX = 0 then
		      Scroll(0, deltaY)
		    else
		      Scroll(-Abs(deltaX) / deltaX, deltaY)
		    End If
		    
		    HidescrollBar = True
		    RefreshTimer.Period = 500
		  End If
		  
		  Return True
		End Function
	#tag EndEvent

	#tag Event
		Sub Opening()
		  Freeze = True
		  
		  
		  DisplayDate = DateTime.Now
		  
		  #if TargetMacOS
		    DisableScroll = True
		  #endif
		  
		  'HideNightTime = True
		  
		  #if TargetDesktop
		    me.AllowFocusRing = False
		    'me.EraseBackground = False
		  #elseif TargetMacOS
		    DoubleBuffer = False
		  #endif
		  me.Animate = False
		  
		  If picLockedEvents is Nil then
		    picLockedEvents = Picture.FromData(DecodeBase64(kPicLockedEvents))
		  End If
		  If picCloseMonthPopup is Nil then
		    picCloseMonthPopup = Picture.FromData(DecodeBase64(kPicCloseMonthPopup))
		  End If
		  
		  
		  
		  
		  
		  '#if not DebugBuild
		  RefreshTimer = New Timer
		  RefreshTimer.Period = 5000
		  RefreshTimer.RunMode = timer.RunModes.Multiple
		  
		  
		  Addhandler RefreshTimer.Action, Weakaddressof TimerAction
		  
		  '#endif
		  
		  
		  MyStyle.MEventHeight = 12
		  TimeWidth = 51
		  minHourHeight = 30
		  ScrollBarWidth = 8
		  minVGap = 10
		  minHGap = 15
		  
		  DisplayWeeknumber = True
		  
		  SetStyle(0)
		  
		  DragEvents = True
		  CreateWithDrag = True
		  
		  HelpTagFormat = "%Start  – %End" + EndOfLine + "%Title – %Location"
		  
		  
		  
		  //Getting day names
		  Today = DateTime.Now
		  
		  //Month Names
		  SetupLocaleInfo()
		  
		  ScrollPosition = (Today.Hour)
		  Freeze = False
		  
		  RaiseEvent Opening()
		  
		  #if TargetDesktop
		    Refresh(False)
		  #elseif TargetWeb
		    Redisplay()
		  #endif
		  
		  
		  
		  //Delete this
		  Call Registered
		  
		  'If not Registered then
		  '#if not DebugBuild
		  'Dim d As new MessageDialog
		  'Dim b As MessageDialogButton
		  '
		  'd.Title = "Demo Software in use"
		  'd.Icon = MessageDialog.GraphicNote
		  'd.ActionButton.Caption="Yes"
		  'd.CancelButton.Visible = True
		  'd.CancelButton.Caption = "No"
		  '
		  'd.Message = "This application was built with a Demo version of CalendarView by Jérémie Leroy." + EndOfLine + _
		  '"If you wish to disable this message, then please encourage the developer of this application to purchase the CalendarView." + EndOfLine + _
		  'EndOfLine + _
		  '"Would you like to visit Jérémie Leroy's website ?"
		  'b=d.ShowModal
		  'If b <> Nil and b=d.ActionButton then
		  'ShowURL("http://www.jeremieleroy.com/")
		  'End If
		  '#endif
		  'End If
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics, areas() As Rect)
		  handlePaint(g, areas())
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AddEvent(cEvent As CalendarEvent)
		  //Adds a CalendarEvent in the CalendarView
		  
		  EventsSorted = False
		  
		  If cEvent.ID = "" then
		    cEvent.ID = "auto" + format(System.Microseconds, "0000000000")
		  End If
		  
		  SelStart = Nil
		  SelEnd = Nil
		  
		  mFirstDate = Nil
		  mLastDate = Nil
		  
		  Events.Add cEvent
		  Redim DisplayEvents(-1)
		  
		  Redisplay()
		  
		  'If RaiseNewEvent then
		  'NewEvent(cEvent)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function AlphaColor(C As Color, Alpha As Color, Force As Boolean = False) As Color
		  If C.Alpha <> 0 and Not Force then
		    Return C
		  End If
		  
		  #if TargetDesktop
		    If TargetWin32 then ' and App.UseGDIPlus = False) then
		      Return Color.RGB(C.Red, C.Green, C.Blue, 0)
		    else
		      Return Color.RGB(C.Red, C.Green, C.Blue, Alpha.Red)
		    End If
		  #elseif TargetWeb
		    Return Color.RGB(C.Red, C.Green, C.Blue, Alpha.Red)
		  #elseif TargetIOS
		    Break
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function AlphaColor(C As Color, Alpha As Integer, Force As Boolean = False) As Color
		  If C.Alpha <> 0 and Not Force then
		    Return C
		  End If
		  
		  #if TargetDesktop
		    If TargetWin32 then 'and App.UseGDIPlus = False) then
		      Return Color.RGB(C.Red, C.Green, C.Blue, 0)
		    else
		      Return Color.RGB(C.Red, C.Green, C.Blue, Alpha*255.0/100.0)
		    End If
		    
		  #Elseif TargetWeb
		    Return Color.RGB(C.Red, C.Green, C.Blue, Alpha*255.0/100.0)
		  #elseif TargetIOS
		    Break
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AutoScroll(deltaX As Integer, deltaY As Integer)
		  //Auto scroll every half second
		  
		  If System.Ticks - lastAutoScroll > 10 then
		    Scroll(deltaX, deltaY)
		    lastAutoScroll = System.Ticks
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CheckRecurringEvents(cEvent As CalendarEvent, FirstDate As DateTime, EndDate As DateTime) As CalendarEvent()
		  
		  
		  Dim Events() As CalendarEvent
		  Dim E As CalendarEvent
		  Dim Recurrence As CalendarRecurrence
		  Dim DisplayDate As DateTime
		  Dim limit As Boolean
		  Dim ExitLoop As Boolean
		  
		  Recurrence = cEvent.Recurrence
		  
		  If Recurrence.EndDate <> Nil and Recurrence.EndDate.SecondsFrom1970 < FirstDate.SecondsFrom1970 then _
		  Return Nil
		  
		  If Recurrence.EndAmount >0 then
		    limit = True
		  End If
		  
		  If FirstDate.SecondsFrom1970 > cEvent.StartDate.SecondsFrom1970 then
		    DisplayDate = New DateTime(FirstDate)
		  Else
		    DisplayDate = New DateTime(cEvent.StartDate) + DIDay
		    //DisplayDate.Day = DisplayDate.Day + 1
		  End If
		  
		  
		  
		  While DisplayDate.SecondsFrom1970 < EndDate.SecondsFrom1970
		    
		    If Recurrence.CreateRecurrence(DisplayDate, cEvent, ExitLoop) then
		      E = cEvent.Clone
		      E.setDate(DisplayDate)
		      E.SetLength(cEvent.Length)
		      Events.Add E
		    End If
		    
		    If ExitLoop then
		      Exit While
		    End If
		    
		    //DisplayDate.Day = DisplayDate.Day + 1
		    DisplayDate = DisplayDate + DIDay
		  Wend
		  
		  
		  
		  Return Events()
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CombSort(ByRef Input() As CalendarEvent)
		  
		  Const Shrink = 1.3
		  Dim swapped As Boolean
		  Dim i, u, gap As Integer
		  Dim swap As CalendarEvent
		  
		  u = Input.LastIndex
		  gap = u
		  
		  
		  while gap > 1 or swapped
		    if gap > 1 then
		      gap = gap / shrink
		    End If
		    
		    swapped = False
		    
		    For i = 0 to u-gap
		      If Input(i) > Input(i+gap) then
		        
		        swap = Input(i)
		        Input(i) = Input(i+gap)
		        Input(i+gap) = swap
		        swapped = True
		      End If
		    Next
		    
		  wend
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DateForXY(x As Integer, y As Integer) As DateTime
		  //newinversion 1.2.1
		  //Finds the Date for the passed x and y.<br/>
		  //If no Date is found, it returns Nil.
		  
		  Dim DrawX, DrawY As Single
		  Dim DrawDate As DateTime
		  Dim i As Integer
		  
		  DrawDate = DateTime.Now
		  DrawDate = DrawDate - New DateInterval(0,0,0,DrawDate.Hour,DrawDate.Minute,DrawDate.Second,DrawDate.Nanosecond)
		  'DrawDate.Hour = 0
		  'DrawDate.Minute = 0
		  'DrawDate.Second = 0
		  
		  If X>=Width then Return Nil
		  
		  If ViewType = TypePicker then
		    
		    If X>=Width then Return Nil
		    
		    'DrawDate.SQLDate = FirstDate.SQLDate
		    DrawDate = Datetime.FromString(FirstDate.SQLDate)
		    
		    Dim HeaderHeight As Integer = 39
		    Dim DayWidth As Single
		    Dim DayHeight As Single
		    
		    Dim ItemsPerLine As Integer
		    Dim TotalItems As Integer
		    
		    Drawy = HeaderHeight
		    Drawx = 0
		    LastDayOver = -1
		    
		    If PickerView = PickerDay then
		      DayWidth = Width / 7
		      DayHeight = (Height - HeaderHeight) / WeeksPerMonth
		      
		      ItemsPerLine = 7
		      TotalItems = WeeksPerMonth * 7
		      
		    elseif PickerView = PickerMonth then
		      DayWidth = Width / 4
		      DayHeight = (Height - HeaderHeight) / 3
		      
		      DrawDate = DrawDate - New DateInterval(0,DrawDate.Month,DrawDate.Day)
		      'DrawDate.Month = 1
		      'DrawDate.Day = 1
		      
		      ItemsPerLine = 4
		      TotalItems = 12
		      
		    End If
		    
		    For i = 1 to TotalItems
		      
		      If x >= DrawX and x < DrawX + DayWidth and y >= DrawY and y < Drawy + DayHeight then
		        LastDayOver = i
		        Return DrawDate
		      End If
		      
		      If PickerView = PickerDay then
		        'DrawDate.Day = DrawDate.Day + 1
		        DrawDate = DrawDate + DIDay
		      elseif PickerView = PickerMonth then
		        'DrawDate.Month = DrawDate.Month + 1
		        DrawDate = DrawDate + New DateInterval(0,1,0)
		      elseif PickerView = PickerYear then
		        'DrawDate.Year = DrawDate.Year + 1
		        DrawDate = DrawDate + New DateInterval(1,0,0)
		      End If
		      
		      If i mod ItemsPerLine = 0 then
		        Drawy = Drawy + DayHeight
		        Drawx = 0
		      else
		        Drawx = Drawx + DayWidth
		      End If
		    Next
		    
		    
		    Return Nil
		    
		  ElseIf ViewType = TypeYear then
		    
		    Dim VAmount As Integer
		    Dim HAmount As Integer
		    Dim VGap As Single
		    Dim HGap As Single
		    HeaderHeight = 22
		    Dim dayWidth As Integer
		    Dim dayHeight As Integer
		    Dim TotalItems, ItemsPerLine, j As Integer
		    Dim kDrawX As Integer
		    
		    If Width > Height then
		      If Width / Height > 2.45 then
		        VAmount = 6
		        HAmount = 2
		      else
		        VAmount = 4
		        HAmount = 3
		      End If
		    else
		      If Width / Height < 0.6 then
		        VAmount = 2
		        HAmount = 6
		      else
		        VAmount = 3
		        HAmount = 4
		      End If
		    End If
		    
		    dayWidth = Floor((Width-(VAmount-1)*minHGap)/(VAmount*7))
		    HGap = (Width - 1-dayWidth * VAmount*7)/(VAmount-1)
		    dayHeight = Floor((Height-(HeaderHeight*HAmount)-minVGap*(HAmount-1))/(6*HAmount))
		    VGap = (Height-1-HeaderHeight*HAmount-dayHeight*6*HAmount)/(HAmount-1)
		    
		    TotalItems = 6*7
		    ItemsPerLine = 7
		    
		    DrawY = HeaderHeight
		    
		    
		    For i = 1 to 12
		      
		      If x >DrawX and x < DrawX + dayWidth * 7 and y > DrawY and y < DrawY + HeaderHeight + dayHeight * 6 then
		        //We found the correct month
		        DrawDate = New DateTime(DisplayDate.Year, i, 1, 0, 0, 0)
		        
		        //Getting the first day of the mini calendar
		        If DrawDate.DayOfWeek - FirstDayOfWeek <= 0 then
		          'DrawDate.Day = DrawDate.Day - (DrawDate.DayOfWeek - FirstDayOfWeek) - 7
		          DrawDate = DrawDate - New DateInterval(0,0,(DrawDate.DayOfWeek - FirstDayOfWeek) + 7)
		        else
		          'DrawDate.Day = DrawDate.Day - (DrawDate.DayOfWeek - FirstDayOfWeek)
		          DrawDate = DrawDate - New DateInterval(0,0,DrawDate.DayOfWeek - FirstDayOfWeek)
		        End If
		        
		        kDrawX = DrawX
		        
		        For j = 1 to TotalItems
		          
		          If x >= DrawX and x < DrawX + DayWidth and y >= DrawY and y < Drawy + DayHeight then
		            Return DrawDate
		          End If
		          
		          'DrawDate.Day = DrawDate.Day + 1
		          DrawDate = DrawDate + DIDay
		          
		          If j mod ItemsPerLine = 0 then
		            Drawy = Drawy + DayHeight
		            Drawx = kDrawX
		          else
		            Drawx = Drawx + DayWidth
		          End If
		        Next
		        
		        //Not found
		        Return Nil
		      End if
		      
		      If i mod VAmount = 0 then
		        DrawX = 0
		        DrawY = DrawY + HeaderHeight + dayHeight * 6 + VGap
		      else
		        DrawX = DrawX + dayWidth * 7 + HGap
		      End If
		    Next
		    
		    //Not found
		    Return Nil
		    
		    
		  ElseIf ViewType = TypeMonth then
		    
		    'DrawDate.SQLDate = FirstDate.SQLDate
		    DrawDate = DateTime.FromString(FirstDate.SQLDate)
		    
		    'Dim HeaderHeight As Integer = 48
		    Dim DayWidth As Single = Width / 7
		    Dim DayHeight As Single = (Height - HeaderHeight) / WeeksPerMonth
		    
		    Drawy = HeaderHeight
		    Drawx = 0
		    For i = 1 to WeeksPerMonth * 7 //A corriger
		      
		      If x >= DrawX and x < DrawX + DayWidth and y >= DrawY and y < Drawy + DayHeight then
		        Return DrawDate
		      End If
		      
		      //DrawDate.Day = DrawDate.Day + 1
		      DrawDate = DrawDate + DIDay
		      If i mod 7 = 0 then
		        Drawy = Drawy + DayHeight
		        Drawx = 0
		      else
		        Drawx = Drawx + DayWidth
		      End If
		    Next
		    
		  elseif ViewType > TypeMonth then
		    
		    If x <= TimeWidth then
		      Return Nil
		    End If
		    If y <= HeaderHeight and SelStart is Nil then
		      Return Nil
		    End If
		    
		    Dim DayWidth As Single = (Width - TimeWidth) / ViewDays
		    
		    //1. Finding Date
		    DrawX = TimeWidth
		    For i = 0 to ViewDays-1
		      If X >= DrawX and X <= DrawX + DayWidth then
		        DrawDate = New DateTime(FirstDate)
		        //DrawDate.Day = DrawDate.Day + i
		        DrawDate = DrawDate + DIDay
		        Exit for i
		      End If
		      DrawX = DrawX + DayWidth
		    Next
		    
		    DrawDate = DrawDate - New DateInterval(0,0,0,DrawDate.Hour, DrawDate.Minute, DrawDate.Second)
		    'DrawDate.Hour = 0
		    'DrawDate.Minute = 0
		    'DrawDate.Second = 0
		    If DayEventClicked then
		      Return DrawDate
		    End If
		    
		    //2. Finding Time
		    DrawY = ViewHeight
		    Dim miny As Integer = ViewHeight - HourHeight
		    DrawY = DrawY - (VisibleHours-(Height-ViewHeight)/HourHeight)*HourHeight*ScrollPosition/VisibleHours
		    
		    If HideNightTime and DayStartHour>0 then
		      DrawY = DrawY + HourHeight
		    End If
		    
		    'For i = DayStartHour to VisibleHours
		    For i = 0 to VisibleHours
		      If DrawY > miny then
		        If Abs(DrawY-y) <= HourHeight / 4 + 1 then
		          DrawDate = DrawDate - New DateInterval(0,0,0,DrawDate.Hour) + New DateInterval(0,0,0,i)
		          //DrawDate.Hour = i
		          exit for i
		        elseif Abs(DrawY+HourHeight\2-y) <= HourHeight\4 then
		          DrawDate = DrawDate - New DateInterval(0,0,0,DrawDate.Hour,DrawDate.Minute) + New DateInterval(0,0,0,i,30)
		          'DrawDate.Hour = i
		          'DrawDate.Minute = 30
		          exit for i
		        Elseif i = 23 and Abs(Height-Y) < HourHeight \ 2 then
		          'DrawDate.Hour = 23
		          'DrawDate.Minute = 59
		          'DrawDate.Second = 59
		          'DrawDate.Day = DrawDate.Day + 1
		          DrawDate = DrawDate + DIDay
		          exit for i
		        End If
		      End If
		      DrawY = DrawY + HourHeight
		    Next
		    
		    Return DrawDate
		  End If
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteAllEvents()
		  //Deletes all CalendarEvents in the CalendarView
		  
		  Redim DisplayEvents(-1)
		  Redim Events(-1)
		  
		  Redisplay()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawBackground(g As Graphics)
		  'If HasBackcolor then
		  'g.DrawingColor = Backcolor
		  'g.FillRectangle(0, 0, g.Width, g.Height)
		  '
		  'else
		  
		  g.DrawingColor = GetWindowColor
		  g.FillRectangle(0, 0, g.Width, g.Height)
		  
		  #if TargetDesktop
		    If me.Window.Backdrop <> Nil then
		      Dim p As Picture = me.Window.Backdrop
		      If me.Left < p.Width and me.Top < p.Height then
		        g.DrawPicture p, 0, 0, Width, Height, left, top, Width, Height
		      End If
		    End If
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawBackgroundMonth(gg As Graphics, WeeksPerMonth As Integer, DayWidth As Single, DayHeight As Single, PrintToday As Boolean = True)
		  //In DebugBuild we check performance of drawing
		  #if DebugBuild
		    Dim ms As Double = System.Microseconds
		  #endif
		  
		  Dim i, u As Integer
		  Dim lText As String
		  Dim x, xx, y As Single
		  Dim DrawDate As DateTime = New DateTime(FirstDate)
		  
		  gg.FontName = TextFont
		  
		  //Header Background
		  If TransparentBackground then
		    #if TargetDesktop
		      #If TargetWin32
		        DrawBackground(gg)
		      #EndIf
		    #endif
		  else
		    gg.DrawingColor = MyColors.Header
		    gg.FillRectangle(0, 0, gg.Width, HeaderHeight)
		  End If
		  
		  //Drawing Day names
		  
		  gg.FontSize = MyStyle.MNumbersTextSize
		  If MyStyle.MDayNameAlign = AlignLeft then
		    xx = MyStyle.MTextOffset
		  elseif MyStyle.MDayNameAlign = AlignCenter then
		    xx = 0
		  else
		    xx = DayWidth - MyStyle.MTextOffset
		  End If
		  
		  Dim gradientDay As Picture
		  If MyStyle.FillGradient then
		    gradientDay = New Picture(Ceiling(DayWidth), Ceiling(DayHeight), 32)
		    gradient(gradientDay.Graphics, 0, gradientDay.Height, MyColors.WeekDay, MyColors.WeekDay2)
		  End If
		  
		  For i = 0 to 6
		    If (FirstDayOfWeek + i) = 7 then
		      lText = DayNames(7).TitleCase
		    else
		      lText = DayNames((FirstDayOfWeek + i) mod 7).Titlecase
		    End If
		    
		    gg.DrawingColor = MyColors.DayName
		    gg.Bold = False
		    
		    If PrintToday and StyleType = StyleOutlook2013 and ((i = Today.DayOfWeek-FirstDayOfWeek) or (i = Today.DayOfWeek-FirstDayOfWeek+7)) then
		      gg.DrawingColor = MyColors.MainColor
		      gg.FillRectangle(DayWidth*i, 29, DayWidth, 19)
		      gg.DrawingColor = MyColors.DayName
		      gg.Bold = True
		    End If
		    
		    
		    If MyStyle.MDayNameAlign = AlignLeft then
		      gg.DrawText(lText, DayWidth * i + xx, 43, DayWidth-xx*2, True)
		    elseif MyStyle.MDayNameAlign = AlignCenter then
		      gg.DrawText(lText, DayWidth * i + max(1, (DayWidth - gg.TextWidth(lText)) \ 2), 43, DayWidth-2, True)
		    elseif MyStyle.MDayNameAlign = 3 then
		      //Do not draw here
		    else
		      x =DayWidth * i + xx - min(DayWidth-xx, gg.TextWidth(lText))
		      gg.DrawText(lText, DayWidth * i + xx - min(xx-3, gg.TextWidth(lText)), 43, DayWidth, True)
		    End If
		    
		    //Drawing Day Background
		    If MyStyle.FillGradient = False then
		      If ColorWeekend and (FirstDayOfWeek + i = 7 or (FirstDayOfWeek + i) mod 7 = 1) then
		        gg.DrawingColor = MyColors.Weekend
		      else
		        gg.DrawingColor = MyColors.WeekDay
		      End If
		      gg.FillRectangle(DayWidth*i, HeaderHeight, Ceiling(DayWidth), gg.Height-HeaderHeight)
		    else
		      For j as integer = 0 to WeeksPerMonth
		        gg.DrawPicture(gradientDay, DayWidth*i, HeaderHeight + j*DayHeight)
		        'gg.gradient(DayWidth*i, HeaderHeight+j*DayHeight, Ceiling(DayWidth), Ceiling(DayHeight), &c363D45, &c2b2c2e)
		      Next
		    End If
		    
		  Next
		  
		  //Drawing title
		  gg.DrawingColor = MyColors.Title
		  gg.Bold = True
		  gg.FontSize = MyStyle.MTitleTextSize
		  If MonthNames.LastIndex>= DisplayDate.Month then
		    lText = MonthNames(DisplayDate.Month) + " " + str(DisplayDate.Year)
		  else
		    lText = Str(DisplayDate.Month) + " " + str(DisplayDate.Year)
		  End If
		  gg.DrawText(lText, (gg.Width - gg.TextWidth(lText)) \ 2, 25, gg.Width, True)
		  
		  
		  
		  
		  //Drawing day numbers
		  gg.FontSize = MyStyle.MNumbersTextSize
		  gg.Bold = False
		  y = HeaderHeight + 14
		  If MyStyle.MDayNumberAlign = AlignLeft then
		    xx = MyStyle.MNumberXOffset
		  elseif MyStyle.MDayNumberAlign = AlignCenter then
		    xx = 1
		  else
		    xx = DayWidth - MyStyle.MNumberXOffset
		  End If
		  x = xx
		  u = WeeksPerMonth * 7
		  Dim Selected As Boolean
		  For i = 1 to u
		    
		    gg.Bold = False
		    Selected = False
		    
		    //Today Background
		    If DrawDate.SQLDate = Today.SQLDate and PrintToday then
		      gg.DrawingColor = MyColors.Today
		      If StyleType = StyleOutlook2013 then
		        gg.FillRectangle(1+(Ceiling(x / DayWidth)-1) * DayWidth, y-13, DayWidth, 5)
		      else
		        gg.FillRectangle(1+(Ceiling(x / DayWidth)-1) * DayWidth, y-13, DayWidth, DayHeight)
		      End If
		    End If
		    
		    //Other Month Background
		    If MyStyle.MColorOtherMonth and DrawDate.Month <> DisplayDate.Month then
		      gg.DrawingColor = MyColors.OtherMonth
		      gg.FillRectangle(1+(Ceiling(x / DayWidth)-1) * DayWidth, y-13, DayWidth, DayHeight)
		    End If
		    
		    //Clicked Background
		    If SelStart <> Nil and SelEnd <> nil and DrawDate.SQLDate >= SelStart.SQLDate and DrawDate.SQLDate <= SelEnd.SQLDate then
		      Selected = True
		      gg.DrawingColor = MyColors.Selected
		      gg.FillRectangle(1+(Ceiling(x / DayWidth)-1) * DayWidth, y-13, DayWidth, DayHeight)
		    End If
		    
		    //Day Header background
		    If MyStyle.MDayNumberBackground then
		      gg.DrawingColor = MyColors.DayNumberBackground
		      gg.FillRectangle(1+(Ceiling(x / DayWidth)-1) * DayWidth, y-13, DayWidth, 16)
		    End If
		    
		    
		    
		    If i<8 and MyStyle.MDayNameAlign = 3 then
		      If (FirstDayOfWeek + i-1) = 7 then
		        lText = DayNames(7).Left(3) + "." + " " + str(DrawDate.Day)
		      else
		        lText = DayNames((FirstDayOfWeek + i-1) mod 7).Left(3) + "." + " " + str(DrawDate.Day)
		      End If
		    else
		      If DrawDate.Day = 1 and MyStyle.MFirstDayOfMonthName then
		        lText = str(DrawDate.Day) + " " + MonthNames(DrawDate.Month)
		      else
		        lText = str(DrawDate.Day)
		        
		      End If
		      If DrawDate.Day = 1 and MyStyle.MFirstDayOfMonthBold then
		        gg.Bold = True
		      End If
		      
		    End If
		    If PrintToday and StyleType = StyleOutlook2013 and DrawDate.SQLDate = Today.SQLDate then
		      //This style has bold lText and special color
		      gg.DrawingColor = MyColors.Today
		      gg.Bold = True
		    elseIf DrawDate.Month <> DisplayDate.Month then
		      If gg.DrawingColor <> MyColors.DayNumber then
		        gg.DrawingColor = MyColors.DayNumber
		      End If
		    else
		      If gg.DrawingColor <> MyColors.DayNumberActive then
		        gg.DrawingColor = MyColors.DayNumberActive
		      End If
		    End If
		    If Selected and MyStyle.MHasSelectedTextColor then
		      gg.DrawingColor = MyColors.MSelectedText
		    End If
		    
		    If MyStyle.MDayNumberAlign = AlignLeft then
		      gg.DrawText(lText, x, y+MyStyle.MNumberYOffset)
		    elseif MyStyle.MDayNumberAlign = AlignCenter then
		      gg.DrawText(lText, x + (DayWidth - gg.TextWidth(lText))\2, y+MyStyle.MNumberYOffset)
		    else
		      gg.DrawText(lText, x - gg.TextWidth(lText), y+MyStyle.MNumberYOffset)
		    End If
		    
		    
		    
		    'DrawDate.Day = DrawDate.Day + 1
		    DrawDate = DrawDate + DIDay
		    If i mod 7 = 0 then
		      y = y + DayHeight
		      x = xx
		    else
		      x = x + DayWidth
		    End If
		  Next
		  
		  
		  //Drawing day frames
		  gg.DrawingColor = MyColors.Line
		  If mHiDPI then
		    For i = 1 to 6
		      x = DayWidth * i
		      gg.FillRectangle(x, HeaderHeight, 2, gg.Height-1)
		    Next
		  else
		    For i = 1 to 6
		      x = DayWidth * i
		      gg.DrawLine(x, HeaderHeight, x, gg.Height-1)
		    Next
		  End If
		  
		  If mHiDPI then
		    For i = 0 to WeeksPerMonth-1
		      y = HeaderHeight + DayHeight * i-1
		      gg.FillRectangle(0, y, gg.Width, 2)
		    Next
		  else
		    For i = 0 to WeeksPerMonth-1
		      y = HeaderHeight + DayHeight * i
		      gg.DrawLine(0, y, gg.Width-1, y)
		    Next
		  End If
		  
		  //Drawing Week numbers
		  If DisplayWeeknumber then
		    If MyStyle.MDayNumberAlign = AlignLeft then
		      x = DayWidth - 24
		    else
		      x = 11
		    End If
		    DrawDate = FirstDate
		    y = HeaderHeight + 5
		    gg.FontSize = 9
		    For i = 0 to WeeksPerMonth-1
		      gg.DrawingColor = MyColors.WeekNumberBackground
		      gg.FillRoundRectangle(x, y, 13, 10, 4, 4)
		      'gg.FillRectangle(x, y, 13, 5)
		      'gg.DrawLine(x, y, x+12, y)
		      
		      gg.DrawingColor = MyColors.WeekNumber
		      if UseISOWeekNumber then
		        lText = str(ISOWeekNumber(DrawDate))
		      Else
		        lText = str(DrawDate.WeekOfYear)
		      end if
		      gg.DrawText(lText, x + (13 - gg.TextWidth(lText))/2, y + 8)
		      
		      'DrawDate.Day = DrawDate.Day + 7
		      DrawDate = DrawDate + DIWeek
		      y = y + DayHeight
		    Next
		  End If
		  
		  //Drawing border
		  If Border then
		    gg.DrawingColor = MyColors.Border
		    gg.DrawRectangle(0, HeaderHeight, gg.Width, gg.Height-HeaderHeight)
		    If mHiDPI then
		      gg.DrawRectangle(1, HeaderHeight-1, gg.Width-2, gg.Height-HeaderHeight)
		    End If
		  End If
		  
		  //In DebugBuild we check performance of drawing
		  #if DebugBuild
		    ms = (System.Microseconds-ms)/1000
		    'DrawInfo = str(ms)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawBackgroundWeek(gg As Graphics, DayWidth As Single, PrintToday As Boolean = True)
		  Dim lText As String
		  Dim i, u As Integer
		  Dim DrawDate As DateTime = New DateTime(FirstDate)
		  Dim y As Integer
		  Dim x As Single
		  Dim gc As Graphics
		  
		  gg.FontName = TextFont
		  
		  
		  //Finding amount of day events for each day
		  //Drawing DragEvent
		  If SelStart <> Nil and SelEnd <> Nil and (SelStart <> SelEnd or DayEventClicked) then
		    Dim E As CalendarEvent = New CalendarEvent("", SelStart, SelEnd)
		    E.FrontMost = True
		    
		    ReDim DisplayEvents(-1)
		    DisplayEvents.Add E
		    SortEvents(FirstDate, LastDate, True)
		  else
		    SortEvents(FirstDate, LastDate)
		  End If
		  u = DisplayEvents.LastIndex
		  
		  DayEventsHeight = max(-1, min(DayEventsHeight, gg.Height\2))
		  
		  If u = -1 then
		    
		    If DayEventsHeight = -1 then
		      ViewHeight = HeaderHeight + MyStyle.WEventHeight + 4
		    else
		      ViewHeight = HeaderHeight + DayEventsHeight
		    End If
		  else
		    //finding amount of DayEvents for the Height of ViewHeight
		    
		    Dim E As CalendarEvent
		    Dim amount() As Integer
		    Dim RemainTime As Double
		    Redim amount(ViewDays-1)
		    Dim idx As Integer
		    For i = 0 to u
		      E = DisplayEvents(i)
		      
		      
		      If E.Length = 0 then
		        y = (E.StartSeconds - FirstDate.SecondsFrom1970) / 86400
		        amount(y) = amount(y) + 1
		      elseif E.StartTime + E.Length >= 86400 then
		        y = max(0, (E.StartSeconds - FirstDate.SecondsFrom1970) / 86400)
		        amount(y) = amount(y) + 1
		        
		        RemainTime = E.Length - (86400-E.StartTime)
		        idx = 1
		        While RemainTime >= 0
		          If y + idx > ViewDays-1 then
		            Exit While
		          else
		            amount(y+idx) = amount(y+idx) + 1
		            RemainTime = RemainTime - 86400
		            idx = idx + 1
		          End If
		        Wend
		      End If
		    Next
		    
		    amount.Sort
		    If DayEventsHeight = -1 then
		      ViewHeight = max(HeaderHeight + MyStyle.WEventHeight + 4, HeaderHeight + amount(ViewDays-1) * MyStyle.WEventHeight + 4)
		    else
		      ViewHeight = HeaderHeight + DayEventsHeight
		    End If
		  End If
		  
		  y = (HeaderHeight - gg.TextHeight)\2 + gg.FontAscent
		  
		  
		  //Drawing Header background
		  If TransparentBackground then
		    #if TargetDesktop
		      If TargetWin32 then 'and not app.UseGDIPlus then
		        DrawBackground(gg)
		      End If
		    #endif
		  else
		    gg.DrawingColor = MyColors.Header
		    gg.FillRectangle(0, 0, gg.Width, HeaderHeight)
		  End If
		  
		  //Drawing Time Background
		  gg.DrawingColor = MyColors.TimeBackground
		  gg.FillRectangle(0, HeaderHeight, TimeWidth, gg.Height-HeaderHeight)
		  
		  //Drawing Year
		  gg.DrawingColor = MyColors.DayName
		  gg.FontSize = MyStyle.WTextSize
		  lText = str(FirstDate.Year)
		  gg.DrawText(lText, (TimeWidth - gg.TextWidth(lText)) \ 2, y)
		  
		  //Drawing Week number
		  If DisplayWeeknumber then
		    gg.DrawingColor = MyColors.WeekNumberBackground
		    gg.FillRoundRectangle((TimeWidth-20)/2, HeaderHeight + 3, 20, MyStyle.WEventHeight-4, 4, 4)
		    
		    if UseISOWeekNumber then
		      lText = str(ISOWeekNumber(DrawDate))
		    Else
		      lText = str(DrawDate.WeekOfYear)
		    End If
		    gg.DrawingColor = MyColors.WeekNumber
		    gg.DrawText(lText, (TimeWidth-gg.TextWidth(lText))\2, HeaderHeight + (MyStyle.WEventHeight-gg.TextHeight) + gg.FontAscent)
		  End If
		  
		  //Drawing day names
		  x = TimeWidth
		  Dim DayStartY As Integer
		  Dim DayEndY As Integer
		  Dim maxWidth As Integer
		  Dim DefaultDateFormat As String = "AbbreviatedDate"
		  If DayStartHour > 0.0 then
		    If HideNightTime then
		      DayStartY = Ceiling(- (VisibleHours-(gg.Height-ViewHeight)/HourHeight)*HourHeight*ScrollPosition/VisibleHours + HourHeight * 1)
		    else
		      DayStartY = Ceiling(- (24-(gg.Height-ViewHeight)/HourHeight)*HourHeight*ScrollPosition/24 + HourHeight * DayStartHour)
		    End If
		  End If
		  If DayEndHour > 0.0 then
		    If HideNightTime then
		      DayEndY = Floor(- (VisibleHours-(gg.Height-ViewHeight)/HourHeight)*HourHeight*ScrollPosition/VisibleHours + HourHeight * DayEndHour)
		    else
		      DayEndY = Floor(- (24-(gg.Height-ViewHeight)/HourHeight)*HourHeight*ScrollPosition/24 + HourHeight * DayEndHour)
		    End If
		  End If
		  gc = gg.Clip(TimeWidth, ViewHeight, gg.Width-TimeWidth, gg.Height-ViewHeight)
		  
		  If WeekHeaderTextFormat = "" then
		    If styleType = StyleOutlook2013 then
		      gg.Bold = true
		    End If
		    For i = 0 to 7
		      'lText = DrawDate.ToString(DateTime.FormatStyles.Long, DateTime.FormatStyles.None)
		      lText = DrawDate.ToString(DateTime.FormatStyles.Long, DateTime.FormatStyles.None)
		      lText = lText.Left(lText.Length-5)
		      If lText.Right(1) = "," then
		        lText = lText.Left(lText.Length - 1)
		      elseif lText.Right(2) = "de" then
		        lText = lText.Left(lText.Length -3)
		      End If
		      
		      maxWidth = max(maxWidth, gg.TextWidth(lText))
		      'DrawDate.Day = DrawDate.Day + 1
		      DrawDate = DrawDate + DIDay
		    Next
		    DrawDate = New DateTime(FirstDate)
		    If maxWidth < DayWidth-6 then
		      DefaultDateFormat = "LongDate"
		    End If
		  End If
		  
		  
		  For i = 0 to ViewDays-1
		    If WeekHeaderTextFormat = "" then
		      If DefaultDateFormat = "LongDate" then
		        lText = DrawDate.ToString(DateTime.FormatStyles.Long, DateTime.FormatStyles.None)
		      else
		        lText = DrawDate.ToString(DateTime.FormatStyles.Medium, DateTime.FormatStyles.None) 'AbbreviatedDate)
		      End If
		      lText = lText.Left(lText.Length-5)
		      If lText.Right(1) = "," then
		        lText = lText.Left(lText.Length - 1)
		      elseif lText.Right(2) = "de" then
		        lText = lText.Left(lText.Length -3)
		      End If
		    else
		      lText = ParseDate(DrawDate, WeekHeaderTextFormat, "Abbreviated Date")
		    End If
		    
		    gg.Bold = False
		    
		    If PrintToday and MyStyle.WTodayHeader and DrawDate.SQLDate = Today.SQLDate then
		      gg.DrawingColor = MyColors.Today
		      gg.FillRectangle(x, 0, DayWidth, HeaderHeight)
		      If StyleType = StyleOutlook2013 then
		        gg.DrawingColor = MyColors.MSelectedText
		        gg.Bold = True
		      else
		        gg.DrawingColor = MyColors.DayName
		      End If
		    else
		      gg.DrawingColor = MyColors.DayName
		    End If
		    
		    gg.DrawText(lText, 3+x + max(0, ( DayWidth-6 - gg.TextWidth(lText)) \ 2), y, DayWidth-6, True)
		    
		    //Drawing day color
		    If PrintToday and DrawDate.SQLDate = Today.SQLDate and MyStyle.WTodayHeader = False then
		      gg.DrawingColor = MyColors.Today
		    ElseIf ColorWeekend and (DrawDate.DayOfWeek = 7 or DrawDate.DayOfWeek = 1) then
		      gg.DrawingColor = MyColors.Weekend
		    else
		      gg.DrawingColor = MyColors.WeekDay
		    End If
		    gg.FillRectangle(DayWidth * i + TimeWidth, HeaderHeight, Ceiling(DayWidth), gg.Height-HeaderHeight)
		    
		    
		    
		    If (DrawDate.DayOfWeek = 7 or DrawDate.DayOfWeek = 1) and ColorWeekend then
		      
		    else
		      If DayStartY > 0 then
		        gc.DrawingColor = ShiftColor(gg.DrawingColor, -5)
		        gc.FillRectangle(DayWidth*i, 0, Ceiling(DayWidth), min(DayStartY, gc.Height))
		        
		      End If
		      If DayEndY < gg.Height-ViewHeight then
		        gc.DrawingColor = ShiftColor(gg.DrawingColor, -5)
		        gc.FillRectangle(DayWidth*i, max(0, DayEndY), Ceiling(DayWidth), gc.Height-DayEndY)
		      End If
		    End If
		    
		    x = x + DayWidth
		    'DrawDate.Day = DrawDate.Day + 1
		    DrawDate = DrawDate + DIDay
		  Next
		  
		  
		  //Drawing Frame
		  gg.DrawingColor = &cD6D6D6
		  gg.DrawLine(0, HeaderHeight, gg.Width-1, HeaderHeight)
		  gg.DrawLine(0, ViewHeight-3, gg.Width-1, ViewHeight-3)
		  gg.DrawLine(0, ViewHeight, gg.Width-1, ViewHeight)
		  gg.DrawingColor = &cEDEDED
		  gg.DrawLine(0, ViewHeight-2, gg.Width-1, ViewHeight-2)
		  gg.DrawingColor = &cE1E1E1
		  gg.DrawLine(0, ViewHeight-1, gg.Width-1, ViewHeight-1)
		  
		  
		  
		  //Drawing horizontal lines
		  y = ViewHeight
		  Dim miny As Integer = y
		  
		  '#if TargetMacOS
		  'y = y - ScrollPosition
		  '#else
		  y = y - (VisibleHours-(gg.Height-ViewHeight)/HourHeight)*HourHeight*ScrollPosition/VisibleHours
		  '#endif
		  
		  For i = 0 to VisibleHours
		    If y > miny then
		      gg.DrawingColor = MyColors.Line
		      gg.DrawLine(MyStyle.WHourLineStartX, y, gg.Width-1, y)
		    End If
		    If y + HourHeight\2 > miny then
		      gg.DrawingColor = ShiftColor(MyColors.Line, MyStyle.WHalfHourColorOffset)
		      If MyStyle.WHalfHourLineStyle = 0 then
		        gg.DrawLine(TimeWidth+1, y+HourHeight\2, gg.Width-1, y+HourHeight\2)
		      else
		        DrawDottedLine(gg, TimeWidth+1, y + HourHeight\2, gg.Width-1, y+HourHeight\2)
		      End If
		    End If
		    
		    y = y + HourHeight
		    If y > gg.Height then
		      exit for i
		    End If
		  Next
		  
		  
		  gg.DrawingColor = MyColors.Line
		  //Drawing vertical lines
		  x = TimeWidth
		  
		  For i = 0 to ViewDays-1
		    gg.DrawLine(x, HeaderHeight, x, gg.Height-1)
		    x = x + DayWidth
		  Next
		  
		  
		  gc = gg.Clip(0, ViewHeight, gg.Width, gg.Height-ViewHeight)
		  
		  //Drawing time
		  DrawDate = New DateTime(FirstDate.Year, FirstDate.Month, FirstDate.Day, 1, 0, 0)
		  'DrawDate.Hour = 1
		  'DrawDate.Minute = 0
		  'DrawDate.Second = 0
		  
		  y = ViewHeight
		  y = y - (VisibleHours-(gg.Height-ViewHeight)/HourHeight)*HourHeight*ScrollPosition/VisibleHours + gg.FontAscent \ 2 - 1 - ViewHeight + HourHeight + MyStyle.WTimeVOffset
		  
		  
		  
		  gc.DrawingColor = MyColors.Time
		  gc.FontSize = MyStyle.WTextSize
		  Dim FirstVisible As Boolean
		  Dim startHour, xx, yy As Integer
		  'Dim HiddenHour As Boolean
		  
		  If HideNightTime then
		    y = y-HourHeight
		    startHour = 0
		    'DrawDate.Hour = 0
		    DrawDate = New DateTime(DrawDate.Year, DrawDate.Month, DrawDate.day, 0, DrawDate.Minute, DrawDate.Second)
		  ElseIf MyStyle.WTimeVOffset>0 then
		    'DrawDate.Hour = 0
		    DrawDate = New DateTime(DrawDate.Year, DrawDate.Month, DrawDate.day, 0, DrawDate.Minute, DrawDate.Second)
		    startHour = 0
		    y = y-HourHeight
		    
		  else
		    startHour = 1
		  End If
		  
		  For i = startHour to VisibleHours
		    
		    If MyStyle.WTimeFormat.IndexOf("(a)")>0 then
		      lText = MyStyle.WTimeFormat
		      If y>gc.FontAscent-gc.TextHeight/2 and not FirstVisible then
		        FirstVisible = True
		        lText = lText.ReplaceBytes("(A)", "A").ReplaceBytes("(a)", "a")
		      elseif DrawDate.Hour=12 then
		        lText = lText.ReplaceBytes("(A)", "A").ReplaceBytes("(a)", "a")
		      else
		        lText = lText.Replace("(a)", "")
		      End If
		      
		    End If
		    //Using other function as it is a long process
		    lText = getTimeTextForWeek(lText, i, startHour, New DateTime(DrawDate))
		    
		    If StyleType = StyleOutlook2013 and MyStyle.WTimeAlign = AlignLeft then
		      
		      If lText.IndexOf(" AM")>0 then
		        lText = lText.Replace("AM", "").Trim
		        xx = gc.TextWidth(lText)
		        yy = gc.FontAscent\2
		        gc.FontSize = 10
		        gc.DrawText(" AM", 3+xx + 2, y-yy)
		        gc.FontSize = MyStyle.WTextSize
		      elseif lText.IndexOf("PM")>0 then
		        lText = lText.Replace("PM", "").Trim
		        xx = gc.TextWidth(lText)
		        yy = gc.FontAscent\2
		        gc.FontSize = 10
		        gc.DrawText(" PM", 3+xx + 2, y-yy)
		        gc.FontSize = MyStyle.WTextSize
		      End If
		    End If
		    
		    If lText.IndexOf(" - ")>0 then
		      gc.FontSize = 10
		      gc.DrawText(lText, 5, y, TimeWidth)
		      gc.FontSize = MyStyle.WTextSize
		    ElseIf MyStyle.WTimeAlign = AlignLeft or lText.IndexOf(" - ")>0 Then
		      gc.DrawText(lText, 5, y)
		    elseif MyStyle.WTimeAlign = AlignCenter then
		      gc.DrawText(lText, (TimeWidth-gg.TextWidth(lText))\2, y, TimeWidth)
		    elseif MyStyle.WTimeAlign = AlignRight then
		      gc.DrawText(lText, TimeWidth - gg.TextWidth(lText)-2, y, TimeWidth)
		    End If
		    
		    
		    'DrawDate.Hour = DrawDate.Hour + 1
		    DrawDate = DrawDate + DIHour
		    If i = startHour and HideNightTime then
		      'DrawDate.Hour = DayStartHour
		      DrawDate = New DateTime(DrawDate.Year, DrawDate.Month, DrawDate.Day, DayStartHour, DrawDate.Minute, DrawDate.Second)
		    End If
		    y = y + HourHeight
		    If y > gg.Height or DrawDate.Hour = 0 then
		      exit for i
		    End If
		  Next
		  
		  //Drawing border
		  If Border then
		    gg.DrawingColor = MyColors.Border
		    gg.DrawRectangle(0, HeaderHeight, gg.Width, gg.Height-HeaderHeight)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawBackgroundYear(gg As Graphics, Print As Boolean = False, PrintToday As Boolean = True)
		  If gg.Height < 50 then Return
		  
		  Dim VAmount As Integer
		  Dim HAmount As Integer
		  Dim MWidth, MHeight As Integer
		  Dim VGap As Single
		  Dim HGap As Single
		  HeaderHeight = 22
		  
		  
		  Dim i, j, k, u As Integer
		  Dim x, y, h As Single
		  Dim xx, yy As Integer
		  
		  Dim dayWidth As Integer
		  Dim dayHeight As Integer
		  
		  Dim lText As String
		  Dim DrawDate As New DateTime(FirstDate)
		  Dim StartDate As DateTime
		  
		  Dim mpic As Picture
		  Dim gm As Graphics
		  
		  gg.FontName = TextFont
		  
		  //Drawing background
		  If Print = False then
		    If TransparentBackground then
		      #if TargetDesktop
		        If TargetWin32 then 'and not app.UseGDIPlus then
		          DrawBackground(gg)
		        End If
		      #endif
		    else
		      gg.DrawingColor = MyColors.YBackground
		      gg.FillRectangle(0, 0, gg.Width, gg.Height)
		    End If
		  End If
		  
		  //Finding amount of months per line
		  If gg.Width > gg.Height then
		    If gg.Width / gg.Height > 2.45 then
		      HAmount = max(1, Ceiling(YearMonthsAmount/6))
		      VAmount = YearMonthsAmount/HAmount
		      'VAmount = 6
		      'HAmount = 2
		    else
		      HAmount = max(1, Ceiling(YearMonthsAmount/4))
		      VAmount = YearMonthsAmount/HAmount
		      'VAmount = 4
		      'HAmount = 3
		    End If
		  else
		    If gg.Width / gg.Height < 0.6 then
		      HAmount = max(1, Ceiling(YearMonthsAmount/6))
		      VAmount = YearMonthsAmount/HAmount
		      'VAmount = 2
		      'HAmount = 6
		    else
		      HAmount = max(1, Ceiling(YearMonthsAmount/4))
		      VAmount = YearMonthsAmount/HAmount
		      'VAmount = 3
		      'HAmount = 4
		    End If
		  End If
		  
		  dayWidth = Floor((gg.Width-(VAmount-1)*minHGap)/(VAmount*7))
		  HGap = (gg.Width - 1-dayWidth * VAmount*7)/(VAmount-1)
		  dayHeight = Floor((gg.Height-(HeaderHeight*HAmount)-minVGap*(HAmount-1))/(6*HAmount))
		  VGap = (gg.Height-1-HeaderHeight*HAmount-dayHeight*6*HAmount)/(HAmount-1)
		  
		  
		  MWidth = dayWidth * 7
		  MHeight = dayHeight * 6
		  
		  //Preparing individual month buffer
		  #if TargetDesktop
		    If TargetWin32 then 'and not App.UseGDIPlus Then
		      mPic = New Picture(MWidth+1, MHeight + HeaderHeight+1, 32)
		    else
		      
		      mPic = New Picture(MWidth+1, MHeight + HeaderHeight+1)
		    End If
		  #elseif TargetWeb
		    mPic = New Picture(MWidth+1, MHeight + HeaderHeight+1)
		  #endif
		  
		  gm = mPic.Graphics
		  
		  
		  
		  gm.DrawingColor = MyColors.Header
		  gm.FillRectangle(0, 0, gm.Width, HeaderHeight)
		  
		  //Drawing Day Names
		  gm.FontName = TextFont
		  #if TargetWeb
		    gm.FontSize = MyStyle.YNumbersTextSize*3/4
		  #else
		    gm.FontSize = MyStyle.YNumbersTextSize'*2
		  #endif
		  Y = gm.FontAscent + gm.TextHeight
		  For i = 0 to 6
		    gm.DrawingColor = MyColors.DayName
		    If (FirstDayOfWeek + i) = 7 then
		      lText = DayNames(7).Titlecase.Left(2)
		    else
		      lText = DayNames((FirstDayOfWeek + i) mod 7).Titlecase.Left(2)
		    End If
		    If gm.TextWidth(lText) > dayWidth-2 then
		      lText = lText.Left(1)
		    End If
		    gm.DrawText(lText, DayWidth * i + max(1, (DayWidth - gm.TextWidth(lText)) \ 2), Y)
		    
		    //Drawing day background
		    If ColorWeekend and ((FirstDayOfWeek + i) = 7 or (FirstDayOfWeek+i) mod 7 = 1) then
		      gm.DrawingColor = MyColors.Weekend
		    else
		      gm.DrawingColor = MyColors.WeekDay
		    End If
		    gm.FillRectangle(dayWidth*i, HeaderHeight, dayWidth+1, gm.Height-HeaderHeight)
		  Next
		  
		  //Drawing day frames
		  gm.DrawingColor = MyColors.Line
		  
		  yy = HeaderHeight+MHeight
		  If MyStyle.YLineVertical > LineNone then
		    For i = 1 to 6
		      xx = DayWidth * i
		      If MyStyle.YLineVertical = LineThinSolid then
		        gm.DrawLine(xx, HeaderHeight, xx, yy)
		      elseif MyStyle.YLineVertical = LineThinDotted then
		        DrawDottedLine(gm, xx, HeaderHeight, xx, yy)
		      elseif MyStyle.YLineVertical = LineThinDouble then
		        gm.DrawLine(xx-1, HeaderHeight, xx-1, yy)
		        gm.DrawingColor = MyColors.Line2
		        gm.DrawLine(xx, HeaderHeight, xx, yy)
		        gm.DrawingColor = MyColors.Line
		      End If
		    Next
		  End If
		  If MyStyle.YLineHorizontal > LineNone then
		    gm.DrawRectangle(0, HeaderHeight, MWidth+1, MHeight+1)
		    For i = 0 to 5
		      yy = HeaderHeight + DayHeight * i
		      If MyStyle.YLineHorizontal = LineThinSolid then
		        gm.DrawLine(0, yy, MWidth, yy)
		      elseif MyStyle.YLineHorizontal = LineThinDotted then
		        DrawDottedLine(gm, 0, yy, MWidth, yy)
		      elseif MyStyle.YLineHorizontal = LineThinDouble then
		        gm.DrawLine(0, yy-1, MWidth, yy-1)
		        gm.DrawingColor = MyColors.Line2
		        gm.DrawLine(0, yy, MWidth, yy)
		        gm.DrawingColor = MyColors.Line
		      End If
		    Next
		  End If
		  
		  If Border then
		    gm.DrawingColor = MyColors.Border
		    gm.DrawRectangle 0, 0, gm.Width, gm.Height
		  End If
		  
		  X = 0
		  Y = 0
		  
		  //Setting up DayColor for each day in the year
		  If DisplayEvents.LastIndex = -1 then
		    SetDayColor()
		  End If
		  u = DisplayEvents.LastIndex
		  
		  For j = 1 to mYearMonthsAmount
		    
		    StartDate = New DateTime(DrawDate.Year, DrawDate.Month, 1, 0, 0, 0)
		    'StartDate.Day = 1
		    'StartDate.Hour = 0
		    'StartDate.Minute = 0
		    'StartDate.Second = 0
		    If StartDate.DayOfWeek - FirstDayOfWeek <= 0 then
		      'StartDate.Day = StartDate.Day - (StartDate.DayOfWeek - FirstDayOfWeek) - 7
		      StartDate = StartDate - New DateInterval(0,0,(StartDate.DayOfWeek - FirstDayOfWeek) + 7)
		    else
		      'StartDate.Day = StartDate.Day - (StartDate.DayOfWeek - FirstDayOfWeek)
		      StartDate = StartDate - New DateInterval(0,0,StartDate.DayOfWeek - FirstDayOfWeek)
		    End If
		    
		    //Drawing Month buffer
		    'gg.DrawPicture(mPic, Floor(X), Floor(Y))
		    gg.DrawPicture(mpic, Floor(X), Floor(Y), MWidth+1, MHeight + HeaderHeight+1, 0, 0, mpic.Width, mpic.Height)
		    
		    //Drawing title
		    gg.DrawingColor = MyColors.Title
		    gg.Bold = True
		    gg.FontSize = MyStyle.YTitleTextSize
		    lText = MonthNames(DrawDate.Month) + " " + str(DisplayDate.Year)
		    gg.DrawText(lText, x + (MWidth - gg.TextWidth(lText)) \ 2, Y+gg.FontAscent, dayWidth*7, True)
		    
		    
		    gg.FontSize = MyStyle.YNumbersTextSize
		    yy = y + HeaderHeight + (dayHeight-gg.TextHeight)\2 + gg.FontAscent
		    xx = x
		    
		    //Drawing Day Numbers and background color for events
		    For i = 1 to 42
		      
		      //Today Background
		      If DrawDate.Month = Today.Month and StartDate.SQLDate = Today.SQLDate and PrintToday then
		        gg.DrawingColor = MyColors.Today
		        gg.FillRectangle(xx+1, Y +1 + HeaderHeight + Floor((i-0.1)/7)*dayHeight, dayWidth-1, dayHeight-1)
		        gg.DrawingColor = mixColor(MyColors.Today, MyColors.Line, &h60)
		        gg.DrawRectangle(xx, Y + HeaderHeight + Floor((i-0.1)/7)*dayHeight, dayWidth+1, dayHeight+1)
		        '1+(Ceiling(x / DayWidth)-1) * DayWidth, y-14, DayWidth, DayHeight)
		      End If
		      
		      //Event Background
		      If StartDate.Month = DrawDate.Month then
		        
		        'If DayColor(StartDate.DayOfYear) <> &c0 then
		        If DayColor(StartDate.DayOfYear) <> Nil then
		          If DayColor(StartDate.DayOfYear).Count = 1 then
		            gg.DrawingColor = DayColor(StartDate.DayOfYear).FirstColor
		            gg.FillRectangle(xx+1, Y +1 + HeaderHeight + Floor((i-0.1)/7)*dayHeight, dayWidth-1, dayHeight-1)
		          else
		            h = (dayHeight-1)/DayColor(StartDate.DayOfYear).Count
		            For k = 0 to DayColor(StartDate.DayOfYear).Count-1
		              gg.DrawingColor = DayColor(StartDate.DayOfYear).EventColor(k)
		              gg.FillRectangle(xx+1, Y+1+h*k+HeaderHeight + Floor((i-0.1)/7)*dayHeight, dayWidth-1, Ceiling(h))
		            Next
		          End If
		          
		        End If
		      End If
		      
		      lText = str(StartDate.Day)
		      If StartDate.Month <> DrawDate.Month then
		        If gg.DrawingColor <> MyColors.DayNumber then
		          gg.DrawingColor = MyColors.DayNumber
		          
		        End If
		      else
		        'If DayColor(StartDate.DayOfYear) <> &c0 then
		        If DayColor(StartDate.DayOfYear) <> Nil then
		          If DayColor(StartDate.DayOfYear).FirstColor.Hue = DayColor(StartDate.DayOfYear).FirstColor.Saturation then
		            If DayColor(StartDate.DayOfYear).FirstColor.Value < 0.5 then
		              gg.DrawingColor = InvertColor(MyColors.DayNumberActive)
		            End if
		            
		          elseif DayColor(StartDate.DayOfYear).FirstColor.Value < 0.9 then
		            gg.DrawingColor = InvertColor(MyColors.DayNumberActive)
		          else
		            gg.DrawingColor = MyColors.DayNumberActive
		          End If
		        elseIf gg.DrawingColor <> MyColors.DayNumberActive then
		          gg.DrawingColor = MyColors.DayNumberActive
		        End If
		      End If
		      
		      gg.DrawText(lText, xx + (DayWidth - gg.TextWidth(lText))\2, yy)
		      
		      'StartDate.Day = StartDate.Day + 1
		      StartDate = StartDate + DIDay
		      If i mod 7 = 0 then
		        yy = yy + DayHeight
		        xx = x
		      else
		        xx = xx + DayWidth
		      End If
		    Next
		    
		    
		    'DrawDate.Day = 1
		    'DrawDate.Month = j+1
		    DrawDate = New DateTime(DrawDate.Year, j+1, 1)
		    
		    If j mod VAmount = 0 then
		      X = 0
		      Y = Y + HeaderHeight + dayHeight * 6 + VGap
		    else
		      X = X + dayWidth * 7 + HGap
		    End If
		  Next
		  
		  '//Drawing border
		  'If Border then
		  'gg.DrawingColor = MyColors.Border
		  'gg.DrawRectangle(0, 0, gg.Width, gg.Height)
		  'End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawDottedLine(g As Graphics, X1 As Integer, Y1 As Integer, X2 As Integer, Y2 As Integer)
		  
		  Dim w As Integer = X2 - X1
		  Dim h As Integer = Y2 - Y1
		  Dim i As Integer
		  If h = 0 then
		    If w > 450 then
		      Dim u As Integer
		      Dim p As Picture
		      #if TargetDesktop
		        If TargetWin32 then 'and not App.UseGDIPlus Then
		          p = New Picture(w, 1, 32)
		          Dim gp As Graphics = p.Graphics
		          gp.DrawingColor = g.DrawingColor
		          gp.DrawLine(0, 0, w, 0)
		          gp = p.CopyMask.Graphics
		          gp.Pixel(1, 0) = &cFFFFFF
		          gp.Pixel(3, 0) = &cFFFFFF
		          
		          i=1
		          u=0
		          while(i<w)
		            i=i*2
		            u=u+1
		          wend
		          w = 4
		          For i = 0 to u
		            gp.DrawPicture(p.CopyMask, w, 0, w, 1, 0, 0, w, 1)
		            w = w*2
		          Next
		          g.DrawPicture(p, X1, Y1)
		          Return
		        Else
		          p = New Picture(w, 1)
		        End If
		      #elseif TargetWeb
		        p = New Picture(w, 1)
		      #endif
		      
		      Dim gp As Graphics = p.Graphics
		      gp.Pixel(0, 0) = g.DrawingColor
		      gp.Pixel(2, 0) = g.DrawingColor
		      
		      i=1
		      u=0
		      while(i<w)
		        i=i*2
		        u=u+1
		      wend
		      w = 4
		      For i = 0 to u
		        gp.DrawPicture(p, w, 0, w, 1, 0, 0, w, 1)
		        w = w*2
		      Next
		      
		      g.DrawPicture(p, X1, Y1)
		    else
		      'If mHiDPI then
		      'For i = 0 to w step 4
		      'g.FillRectangle(X1+i, Y1, 2, 2)
		      'Next
		      'else
		      For i = 0 to w step 2
		        g.Pixel(X1+i, Y1) = g.DrawingColor
		      Next
		      'End If
		    End If
		  else
		    If h > 450 then
		      Dim u As Integer
		      Dim p As Picture
		      #if TargetDesktop
		        If TargetWin32 then 'and not App.UseGDIPlus Then
		          p = New Picture(1, h, 32)
		          Dim gp As Graphics = p.Graphics
		          gp.DrawingColor = g.DrawingColor
		          gp.DrawLine(0, 0, 0, h)
		          gp = p.CopyMask.Graphics
		          gp.Pixel(0, 1) = &cFFFFFF
		          gp.Pixel(0, 3) = &cFFFFFF
		          
		          i=1
		          u=0
		          while(i<h)
		            i=i*2
		            u=u+1
		          wend
		          h = 4
		          For i = 0 to u
		            gp.DrawPicture(p.CopyMask, 0, h, 1, h, 0, 0, 1, h)
		            h = h*2
		          Next
		          
		          g.DrawPicture(p, X1, Y1)
		          Return
		        Else
		          p = New Picture(w, 1)
		        End If
		      #elseif TargetWeb
		        p = New Picture(w, 1)
		      #endif
		      Dim gp As Graphics = p.Graphics
		      gp.Pixel(0,0) = g.DrawingColor
		      gp.Pixel(0,2) = g.DrawingColor
		      
		      i=1
		      u=0
		      while(i<h)
		        i=i*2
		        u=u+1
		      wend
		      h = 4
		      For i = 0 to u
		        gp.DrawPicture(p, 0, h, 1, h, 0, 0, 1, h)
		        h = h*2
		      Next
		      g.DrawPicture(p, X1, Y1)
		    else
		      'If mHiDPI then
		      'For i = 0 to h step 4
		      'g.FillRectangle(X1, Y1+i, 2, 2)
		      'Next
		      'else
		      For i = 0 to h step 2
		        g.Pixel(X1, Y1+i) = g.DrawingColor
		      Next
		      'End If
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawEvent(g As Graphics, E As CalendarEvent, X As Integer, Y As Integer, Width As Integer, Height As Integer, DayEvent As Boolean)
		  #if TargetWeb
		    Height = Height-1
		  #endif
		  
		  Dim gp As Graphics
		  Dim p As Picture
		  Dim Antialiasing As Boolean
		  
		  #if TargetWin32 and TargetDesktop
		    '>>>>>>>>>>>>>>>>>>>>>>>> First try with antialiasing
		    'If App.UseGDIPlus then
		    gp = g.Clip(X, Y, Width, Height)
		    Antialiasing = True
		    'Else
		    'p = New Picture(Width, Height, 32)
		    'If p is Nil then Return
		    'gp = p.Graphics
		    'Antialiasing = False
		    'End If
		  #Else
		    gp = g.Clip(X, Y, Width, Height)
		    Antialiasing = True
		  #endif
		  
		  Dim Arc As Integer = 6
		  
		  Dim HeaderHeight As Integer
		  If ViewType >= TypeWeek then
		    HeaderHeight = MyStyle.WHeaderHeight
		  End If
		  
		  Dim Transparency As Color
		  If ViewType = TypeMonth then
		    If MyStyle.MDayTransparent then
		      Transparency = MyStyle.MDayTransparency
		    End If
		  elseif ViewType >= TypeWeek then
		    Transparency = MyStyle.WBodyTransparency
		  End If
		  
		  
		  //Drawing background color
		  If MyStyle.WRoundRect then //RoundRect
		    
		    If MyStyle.WBodyColorOffset1 = MyStyle.WBodyColorOffset2 then //No gradient
		      
		      gp.DrawingColor = AlphaColor(E.EventColor, Transparency)
		      
		      If Antialiasing then
		        gp.FillRoundRectangle(0, 0, gp.Width, gp.Height, Arc, Arc)
		      else
		        gp.FillRectangle(0, 0, gp.Width, gp.Height)
		      End If
		      
		      If HeaderHeight > 0 and not DayEvent then
		        gp.DrawingColor = mixColor(E.EventColor, &cFFFFFF, MyStyle.WHeaderColorOffset)
		        gp.FillRoundRectangle(1, 1, gp.Width-2, 1+HeaderHeight, Arc,Arc)
		        gp.FillRectangle(1, 1+HeaderHeight-2, gp.Width-2, 3)
		      End If
		      
		      If HeaderHeight>0 then
		        gp.DrawingColor = AlphaColor(mixColor(E.EventColor, &cFFFFFF, MyStyle.WBodyColorOffset1), Transparency)
		        gp.FillRoundRectangle(1, 1 + HeaderHeight, gp.Width-2, gp.Height - 2 - HeaderHeight, Arc, Arc)
		        gp.FillRectangle(1, 1 + HeaderHeight, gp.Width-2, 3)
		      End If
		      
		    else //Gradient
		      
		      If MyStyle.WBodyGradientVertical then
		        gradient2(gp, 1, 1+HeaderHeight, gp.Width-2, gp.Height - 2 - HeaderHeight, _
		        shiftColor(E.EventColor, MyStyle.WBodyColorOffset1), _
		        ShiftColor(E.EventColor, MyStyle.WBodyColorOffset2), True)
		      else
		        gradient2(gp, 1, 1, gp.Width-2, gp.Height-2, _
		        shiftColor(E.EventColor, MyStyle.WBodyColorOffset1), _
		        ShiftColor(E.EventColor, MyStyle.WBodyColorOffset2), False)
		      End If
		      
		      gp.DrawingColor = E.EventColor
		      
		      gp.DrawRoundRectangle(0, 0, gp.Width, gp.Height, Arc,Arc)
		      If not Antialiasing then
		        gp.DrawRectangle(0, 0, gp.Width, gp.Height)
		        gp.DrawRoundRectangle(0, 0, gp.Width, gp.Height, 8,8)
		      End If
		      
		      If HeaderHeight > 0 and not DayEvent then
		        gp.DrawingColor = mixColor(E.EventColor, &cFFFFFF, MyStyle.WHeaderColorOffset)
		        gp.FillRoundRectangle(1, 1, gp.Width-2, 1+HeaderHeight, Arc,Arc)
		        gp.FillRectangle(1, 1+HeaderHeight-2, gp.Width-2, 3)
		      End If
		    End If
		    
		    
		    If not Antialiasing then
		      gp = p.CopyMask.Graphics
		      
		      //Drawing picture mask
		      gp.DrawingColor = &cFFFFFF
		      gp.FillRectangle(0, 0, gp.Width, gp.Height)
		      gp.DrawingColor = &cDDDDDD
		      gp.DrawRoundRectangle(0, 0, gp.Width, gp.Height, 4, 4)
		      gp.DrawingColor = &c888888
		      gp.DrawRoundRectangle(0, 0, gp.Width, gp.Height, Arc, Arc)
		      gp.DrawingColor = &c0
		      gp.DrawRoundRectangle(0, 0, gp.Width, gp.Height, 8, 8)
		      gp.Pixel(1, 1) = &c707070
		      gp.Pixel(gp.Width-2, 1) = &c707070
		      gp.Pixel(1, gp.Height-2) = &c707070
		      gp.Pixel(gp.Width-2, gp.Height-2) = &c707070
		      
		      
		      If Transparency <> &c0 or MyStyle.WHeaderTransparency <> &c0 then
		        
		        If DayEvent then
		          gp.DrawingColor = Transparency
		          gp.FillRoundRectangle(1, 1, gp.Width-2, gp.Height-2, Arc, Arc)
		          
		        Else //not WholeDay
		          
		          If HeaderHeight > 0  then
		            gp.DrawingColor = MyStyle.WHeaderTransparency
		            gp.FillRoundRectangle(1, 1, gp.Width-2, 1+HeaderHeight, Arc,Arc)
		            gp.FillRectangle(1, 1+HeaderHeight-3, gp.Width-2, 3)
		          End If
		          gp.DrawingColor = Transparency
		          gp.FillRoundRectangle(1, 1+HeaderHeight, gp.Width-2, gp.Height-2-HeaderHeight, Arc, Arc)
		          If HeaderHeight > 0 then
		            gp.FillRectangle(1, 1+HeaderHeight, gp.Width-2, 3)
		          End If
		          
		          
		          
		        End If
		      else
		        gp.DrawingColor = &c0
		        gp.FillRoundRectangle(1, 1, gp.Width-2, gp.Height-2, Arc, Arc)
		      End If
		    End If
		    
		  Else //not RoundRect
		    
		    If MyStyle.WEventFill = FillSolid then //No gradient
		      
		      gp.DrawingColor = AlphaColor(mixColor(E.EventColor, &cFFFFFF, MyStyle.WBodyColorOffset1), Transparency)
		      
		      gp.FillRectangle(1, 1 + HeaderHeight, gp.Width-2, gp.Height - 2 - HeaderHeight)
		    elseif MyStyle.WEventFill = FillGradientVertical then
		      
		      gradient(gp, 1+ HeaderHeight, gp.Height - 1 - HeaderHeight, shiftColor(E.EventColor, MyStyle.WBodyColorOffset1), _
		      ShiftColor(E.EventColor, MyStyle.WBodyColorOffset2), True, Transparency.Red)
		    elseif MyStyle.WEventFill = FillGradientHorizontal Then
		      gradient(gp, 1, gp.Width-2, shiftColor(E.EventColor, MyStyle.WBodyColorOffset1), _
		      ShiftColor(E.EventColor, MyStyle.WBodyColorOffset2), False, Transparency.Red)
		      
		      //Outlook 2013 Style
		    elseif MyStyle.WEventFill = FillOutlook2013 then
		      gp.DrawingColor = AlphaColor(E.EventColor, Transparency)
		      gp.FillRectangle(0, 0, 8, gp.Height)
		      gp.DrawingColor = Alphacolor(ShiftColor(E.EventColor, MyStyle.MColorOffset1), Transparency)
		      gp.FillRectangle(8, 0, gp.Width, gp.Height)
		      If E.DayEvent then
		        gp.DrawingColor = &cFFFFFF
		        gp.FillRectangle(1, 1, 6, gp.Height-2)
		      End If
		    End If
		    
		    //Drawing border
		    If MyStyle.WEventFill <> FillOutlook2013 then
		      gp.DrawingColor = E.EventColor
		      gp.DrawRectangle(0, 0, gp.Width, gp.Height)
		    End If
		    If HeaderHeight > 0 then
		      gp.DrawingColor = mixColor(E.EventColor, &cFFFFFF, MyStyle.WHeaderColorOffset)
		      gp.FillRectangle(1, 1, gp.Width-2, HeaderHeight)
		    End If
		    
		    If not Antialiasing then
		      'gp = p.CopyMask.Graphics
		      'If HeaderHeight > 0 and MyStyle.WHeaderTransparency <> &c0 then
		      '//Drawing picture mask
		      'gp.DrawingColor = MyStyle.WHeaderTransparency
		      'gp.FillRectangle(1, 1, gp.Width-2, HeaderHeight)
		      'End If
		      'If Transparency <> &c0 then
		      'gp.DrawingColor = Transparency
		      'gp.FillRectangle(1, HeaderHeight+1, gp.Width-2, gp.Height-HeaderHeight-2)
		      'End If
		    End If
		    
		    
		    
		  End If
		  
		  If HighlightLockedEvents and E.Editable = False then
		    If ViewType = TypeMonth or E.DayEvent then
		      DrawTexture(gp, picLockedEvents, True, False)
		    Elseif ViewType > TypeMonth then
		      DrawTexture(gp, picLockedEvents, True, True)
		    End If
		  End If
		  
		  If not Antialiasing Then
		    g.DrawPicture(p, X, Y)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawEventsMonth(gg As Graphics, WeeksPerMonth As Integer, DayWidth As Single, DayHeight As Single)
		  'Dim mp As new MethodProfiler(CurrentMethodName)
		  If DayHeight < 30 then Return
		  If DayWidth < 30 then Return
		  
		  If Events.LastIndex = -1 then Return
		  
		  Dim i, j, u, Idx, DrawIdx, RealLength, v, LeftOffset As Integer
		  Dim lText As String
		  Dim x, xx,y, yy As Single
		  Dim E As CalendarEvent
		  Dim DrawDate As DateTime '= DateTime.Now
		  'DrawDate.Hour = 0
		  'DrawDate.Minute = 0
		  'DrawDate.Second = 0
		  DrawDate = DateTime.FromString(FirstDate.SQLDate)
		  'DrawDate.Day = DrawDate.Day + 1
		  Dim okToDraw As Boolean
		  
		  Dim MonthPopupX, MonthPopupY As Integer
		  
		  If DisplayEvents.LastIndex = -1 or DragEvent = DragMove Then
		    SortEvents(FirstDate, LastDate)
		  End If
		  
		  u = DisplayEvents.LastIndex
		  If u = -1 then Return
		  
		  y = HeaderHeight+17+MyStyle.MNumberYOffset
		  x = 0
		  LeftOffset = MyStyle.MLeftOffset
		  
		  'Dim amount() As Integer
		  'Redim amount(WeeksPerMonth * 7)
		  
		  Dim DrawPos As New CalendarDrawPosition(WeeksPerMonth*7, (DayHeight-17-MyStyle.MNumberYOffset) / (MyStyle.MEventHeight+1) -1)
		  
		  For i = 1 to WeeksPerMonth * 7
		    okToDraw = True
		    
		    If DrawDate.Day = 12 then
		      i = i
		    End If
		    
		    For j = Idx to u
		      
		      E = DisplayEvents(j)
		      
		      If E.StartDate.SQLDate > DrawDate.SQLDate then
		        Idx = j
		        Exit for j
		      End If
		      
		      If (DrawDate.SQLDate = E.StartDate.SQLDate) or (i=1 and DrawDate > E.StartDate) then
		        
		        If okToDraw then
		          'If j<u and DisplayEvents(j+1).Day = E.Day and DrawPos.Remain((E.StartSeconds - FirstDate.SecondsFrom1970) / 86400) <2 then
		          If j < u and DisplayEvents(j+1).StartDate.SQLDate <= E.EndDate.SQLDate and DrawPos.Remain(max(0, (DisplayEvents(j+1).StartSeconds - FirstDate.SecondsFrom1970) / 86400)) < 1 then
		            okToDraw = False
		          else
		            v = DrawPos.Remain(max(0, (E.StartSeconds - FirstDate.SecondsFrom1970) / 86400))
		            If v < 1 and DrawPos.Hidden(i) > 0 then
		              okToDraw = False
		            elseif v < 0 then
		              okToDraw = False
		            else
		              okToDraw = True
		            End If
		          End If
		        End If
		        
		        yy = DrawPos.Search(max(0, (E.StartSeconds - FirstDate.SecondsFrom1970) / 86400), E.Length/86400) * (MyStyle.MEventHeight+1)
		        
		        If not okToDraw then
		          DrawPos.AddHidden(i, E.Length/86400)
		          E.Visible = False
		          E.drawX = x
		          E.DrawY = y + yy
		          E.DrawW = DayWidth
		          E.DrawH = MyStyle.MEventHeight
		          Continue For j
		          
		        End If
		        
		        E.Visible = True
		        'yy = DrawPos.Search(max(0, (E.StartSeconds - FirstDate.SecondsFrom1970) / 86400), E.Length/86400) * (MyStyle.MEventHeight+1)
		        
		        //Event is a whole day event
		        If E.StartDate.Hour = 0 and E.StartDate.Minute = 0 and E.Length mod 86400 = 0 or E.Length > 86400 then
		          RealLength = Floor(E.Length / 86400) + 1 - max(0, (FirstDate.SecondsFrom1970 - E.StartSeconds) / 86400)
		          
		          //Only events that start at 0:00 and length mod 86400=0 have to be set as DayEvents
		          If E.StartDate.Hour = 0 and E.StartDate.Minute = 0 and E.Length mod 86400 = 0 then
		            E.DayEvent = True
		          End If
		          
		          
		          //Should go on to the next week line
		          If RealLength>7 or x+RealLength*DayWidth>gg.Width+5 Then
		            
		            Dim remainDays As Integer = RealLength
		            DrawIdx = 0
		            xx = x
		            
		            Dim textColorEvent As Color = MyStyle.WTextColor
		            
		            If StyleType = StyleOutlook2013 then
		              textColorEvent= mixColor(E.EventColor, &c0, &hB0)
		            else
		              If E.EventColor.Hue = E.EventColor.Saturation then
		                If E.EventColor.Value < 0.5 then
		                  textColorEvent = InvertColor(textColorEvent)
		                End if
		              elseif E.EventColor.Value < 0.9 then
		                textColorEvent = InvertColor(textColorEvent)
		              End If
		            End If
		            
		            
		            While remainDays>0
		              DrawEvent(gg, E, xx, y + yy + DayHeight*DrawIdx, _
		              DayWidth * min(7, remainDays) - LeftOffset * 2, MyStyle.MEventHeight, _
		              E.DayEvent)
		              
		              If DrawIdx = 0 then
		                remainDays = remainDays - (7-Round(x/DayWidth))
		              else
		                
		                
		                //Drawing lText
		                gg.DrawingColor = textColorEvent
		                gg.FontSize = MyStyle.MEventTextSize
		                gg.Bold = MyStyle.MDayTextBold
		                If E.DayEvent then
		                  gg.DrawText(E.Title, xx+MyStyle.MTextOffset, y + yy +DayHeight*DrawIdx+ (MyStyle.MEventHeight-gg.TextHeight)\2 + gg.FontAscent, remainDays * DayWidth-MyStyle.MTextOffset*2, True)
		                End If
		                
		                remainDays = remainDays - 7
		                
		              End If
		              
		              xx = MyStyle.MLeftOffset
		              DrawIdx = DrawIdx + 1
		            Wend
		            
		          else
		            //testing
		            DrawEvent(gg, E, x+MyStyle.MLeftOffset, y + yy, _
		            DayWidth * max(1, min(RealLength, 43)) - LeftOffset * 2, MyStyle.MEventHeight, _
		            E.DayEvent)
		            'gg.DrawPicture(p, x+MyStyle.MLeftOffset, y+yy)
		          End If
		          
		          E.drawX = x
		          E.DrawY = y + yy
		          E.DrawW = DayWidth*RealLength
		          E.DrawH = MyStyle.MEventHeight
		          
		          //Drawing lText
		          gg.DrawingColor = MyStyle.WTextColor
		          If StyleType = StyleOutlook2013 then
		            gg.DrawingColor = mixColor(E.EventColor, &c0, &hB0)
		          else
		            If E.EventColor.Hue = E.EventColor.Saturation then
		              If E.EventColor.Value < 0.5 then
		                gg.DrawingColor = InvertColor(gg.DrawingColor)
		              End if
		            elseif E.EventColor.Value < 0.9 then
		              gg.DrawingColor = InvertColor(gg.DrawingColor)
		            End If
		          End If
		          gg.FontSize = MyStyle.MEventTextSize
		          gg.Bold = MyStyle.MDayTextBold
		          If E.DayEvent then
		            gg.DrawText(E.Title, x+MyStyle.MTextOffset, y + yy + (MyStyle.MEventHeight-gg.TextHeight)\2 + gg.FontAscent, max(1, E.Length/86400+1) * DayWidth-MyStyle.MTextOffset*2, True)
		          else
		            gg.DrawText(E.StartDate.ToString(DateTime.FormatStyles.Short, datetime.FormatStyles.None) + " " + E.Title, x+MyStyle.MTextOffset, y + yy + (MyStyle.MEventHeight-gg.TextHeight)\2 + gg.FontAscent, max(1, E.Length/86400+1) * DayWidth-MyStyle.MTextOffset*2, True)
		          End If
		          
		        else //Not a whole day event
		          
		          E.drawX = x
		          E.DrawY = y + yy
		          E.DrawW = DayWidth
		          E.DrawH = MyStyle.MEventHeight
		          
		          //Drawing lText
		          gg.DrawingColor = E.EventColor
		          
		          If MyStyle.MEventFill = FillOutlook2013 then
		            //testing
		            DrawEvent(gg, E, x+MyStyle.MLeftOffset, y + yy, _
		            DayWidth - LeftOffset * 2+1, MyStyle.MEventHeight, False)
		            
		          End If
		          
		          gg.FontSize = MyStyle.MEventTextSize
		          gg.Bold = MyStyle.MHourBold
		          lText = E.StartDate.ToString(DateTime.FormatStyles.None, DateTime.FormatStyles.Short) + " "
		          gg.DrawText(lText, x+MyStyle.MTextOffset,y+ yy + (MyStyle.MEventHeight-gg.TextHeight)\2 + gg.FontAscent, DayWidth-MyStyle.MTextOffset*2, True)
		          xx = gg.TextWidth(lText)
		          gg.Bold = MyStyle.MTextBold
		          gg.DrawText(E.Title, x+MyStyle.MTextOffset + xx, y+yy + (MyStyle.MEventHeight-gg.TextHeight)\2 + gg.FontAscent, DayWidth - MyStyle.MTextOffset - xx, True)
		          
		        end if //End of Drawing event
		        
		        
		        
		        'yy = yy + MyStyle.MEventHeight +1
		        
		        
		        
		      elseIf E.Visible = False then //Event doesn't start on that day but we make sure it's space is locked+
		        If E.StartDate.SQLDate < DrawDate.SQLDate and E.EndDate.SQLDate >= DrawDate.SQLDate then
		          Call DrawPos.LockLast((E.StartSeconds - FirstDate.SecondsFrom1970) / 86400, E.Length / 86400)
		          'DrawPos.AddHidden(i, E.Length / 86400)
		        End If
		        
		      End If
		      
		      
		    Next
		    
		    //Drawing the +xx hidden events
		    If DrawPos.Hidden(i) > 0 then
		      gg.FontSize = MyStyle.MEventTextSize
		      gg.DrawingColor = &c0000FF
		      yy = DrawPos.LockLast((DrawDate.SecondsFrom1970 - FirstDate.SecondsFrom1970) / 86400, 0) * (MyStyle.MEventHeight+1)
		      'yy = DrawPos.Search(max(0, (E.StartSeconds - FirstDate.SecondsFrom1970) / 86400), E.Length/86400) * (MyStyle.MEventHeight+1)
		      If MoreEventsDate <> Nil and MoreEventsDate.SQLDate = DrawDate.SQLDate then
		        gg.Underline = True
		      End If
		      
		      gg.DrawText("+" + str(DrawPos.Hidden(i)), x+MyStyle.MTextOffset, y + yy + (MyStyle.MEventHeight-gg.TextHeight)\2 + gg.FontAscent)
		      If gg.Underline then
		        gg.Underline = False
		      End If
		    End If
		    
		    If MonthsPopup.Visible and DrawDate.SQLDate = MonthsPopup.SQLDate then
		      MonthPopupX = x
		      MonthPopupY = y-17-MyStyle.MNumberYOffset
		    End If
		    
		    If i mod 7 = 0 then
		      y = y + DayHeight
		      x = 0
		    else
		      x = x + DayWidth
		    End If
		    
		    'DrawDate.Day = DrawDate.Day + 1
		    DrawDate = DrawDate + DIDay
		  Next
		  
		  If MonthsPopup.Visible then
		    DrawMonthPopup(gg, MonthPopupX, MonthPopupY, Round(DayWidth)+1, Round(DayHeight)+1)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawEventsMonth_old(gg As Graphics, WeeksPerMonth As Integer, DayWidth As Single, DayHeight As Single)
		  #Pragma Unused gg
		  #Pragma Unused WeeksPerMonth
		  #Pragma Unused DayWidth
		  #Pragma Unused DayHeight
		  
		  #if False
		    'Dim mp As new MethodProfiler(CurrentMethodName)
		    If DayHeight < 30 then Return
		    If DayWidth < 30 then Return
		    
		    If Events.LastIndex = -1 then Return
		    
		    Dim i, j, k, u, Idx, DrawIdx, RealLength, v, DeltaX, LeftOffset As Integer
		    Dim lText As String
		    Dim x, xx,y, yy As Single
		    Dim p As Picture
		    Dim gp As Graphics
		    Dim E As CalendarEvent
		    Dim DrawDate As DateTime '= New DateTime
		    'DrawDate.Hour = 0
		    'DrawDate.Minute = 0
		    'DrawDate.Second = 0
		    DrawDate = DateTime.FromString(FirstDate.SQLDate)
		    'DrawDate.Day = DrawDate.Day + 1
		    Dim okToDraw As Boolean
		    
		    If DisplayEvents.LastIndex = -1 Then
		      SortEvents(FirstDate, LastDate)
		    End If
		    
		    u = DisplayEvents.LastIndex
		    If u = -1 then Return
		    
		    y = HeaderHeight+17+MyStyle.MNumberYOffset
		    x = 0
		    LeftOffset = MyStyle.MLeftOffset
		    
		    'Dim amount() As Integer
		    'Redim amount(WeeksPerMonth * 7)
		    
		    Dim DrawPos As New CalendarDrawPosition(WeeksPerMonth*7, (DayHeight-17) / (MyStyle.MEventHeight+1) -1)
		    
		    For i = 1 to WeeksPerMonth * 7
		      okToDraw = True
		      
		      For j = Idx to u
		        
		        E = DisplayEvents(j)
		        
		        If E.StartDate.SQLDate > DrawDate.SQLDate then
		          Idx = j
		          Exit for j
		        End If
		        
		        If (DrawDate.SQLDate = E.StartDate.SQLDate) or (i=1 and DrawDate > E.StartDate) then
		          
		          If okToDraw then
		            'If j<u and DisplayEvents(j+1).Day = E.Day and DrawPos.Remain((E.StartSeconds - FirstDate.SecondsFrom1970) / 86400) <2 then
		            If j < u and DisplayEvents(j+1).StartSeconds <= E.EndSeconds and DrawPos.Remain(max(0, (DisplayEvents(j+1).StartSeconds - FirstDate.SecondsFrom1970) / 86400)) < 1 then
		              okToDraw = False
		            else
		              v = DrawPos.Remain(max(0, (E.StartSeconds - FirstDate.SecondsFrom1970) / 86400))
		              If v < 1 and DrawPos.Hidden(i) > 0 then
		                okToDraw = False
		              elseif v < 0 then
		                okToDraw = False
		              else
		                okToDraw = True
		              End If
		            End If
		          End If
		          
		          
		          If not okToDraw then
		            DrawPos.AddHidden(i, E.Length/86400)
		            E.Visible = False
		            Continue For j
		            
		          End If
		          
		          E.Visible = True
		          yy = DrawPos.Search(max(0, (E.StartSeconds - FirstDate.SecondsFrom1970) / 86400), E.Length/86400) * (MyStyle.MEventHeight+1)
		          
		          //Event is a whole day event
		          If E.StartDate.Hour = 0 and E.StartDate.Minute = 0 and E.Length mod 86400 = 0 or E.Length > 86400 then
		            RealLength = Floor(E.Length / 86400) + 1 - max(0, (FirstDate.SecondsFrom1970 - E.StartSeconds) / 86400)
		            
		            //Only events that start at 0:00 and length mod 86400=0 have to be set as DayEvents
		            If E.StartDate.Hour = 0 and E.StartDate.Minute = 0 and E.Length mod 86400 = 0 then
		              E.DayEvent = True
		            End If
		            
		            
		            p = New Picture(DayWidth * max(1, min(RealLength, 43)) - LeftOffset * 2+1, MyStyle.MEventHeight, 32)
		            gp = p.Graphics
		            
		            
		            //Drawing background color
		            If MyStyle.MColorOffset1 <> MyStyle.MColorOffset2 then
		              If MyStyle.MEventFill = FillGradientVertical then
		                gradient(gp, 0, gp.Height, ShiftColor(E.EventColor, MyStyle.MColorOffset1), ShiftColor(E.EventColor, MyStyle.MColorOffset2), True)
		              elseif MyStyle.MEventFill = FillGradientHorizontal then
		                gradient(gp, 0, gp.Width, ShiftColor(E.EventColor, MyStyle.MColorOffset1), ShiftColor(E.EventColor, MyStyle.MColorOffset2), False)
		              elseif MyStyle.MEventFill = FillSolid then
		                gp.DrawingColor = E.EventColor
		                gp.FillRectangle(0, 0, gp.Width, gp.Height)
		              elseif MyStyle.MEventFill = FillOutlook2013 then
		                gp.DrawingColor = E.EventColor
		                gp.FillRectangle(0, 0, 8, gp.Height)
		                gp.DrawingColor = ShiftColor(E.EventColor, MyStyle.MColorOffset1)
		                gp.FillRectangle(8, 0, gp.Width, gp.Height)
		                If E.DayEvent then
		                  gp.DrawingColor = &cFFFFFF
		                  gp.FillRectangle(1, 1, 6, gp.Height-2)
		                End If
		              End If
		              If MyStyle.MBorderSolid then
		                gp.DrawingColor = E.EventColor
		                gp.DrawRectangle(0, 0, gp.Width, gp.Height)
		                If MyStyle.MDayRoundRect then
		                  gp.DrawRoundRectangle(0, 0, gp.Width, gp.Height, 6, 6)
		                  gp.DrawRoundRectangle(0, 0, gp.Width, gp.Height, 8, 8)
		                End If
		              End If
		            else
		              gp.DrawingColor = ShiftColor(E.EventColor, MyStyle.MColorOffset1)
		              gp.FillRectangle(0, 0, gp.Width, gp.Height)
		            End If
		            
		            If MyStyle.MDayRoundRect or MyStyle.MDayTransparent then
		              
		              //Drawing picture mask
		              gp = p.CopyMask.Graphics
		              gp.DrawingColor = &cFFFFFF
		              gp.FillRectangle(0, 0, gp.Width, gp.Height)
		              If MyStyle.MDayRoundRect then
		                
		                gp.DrawingColor = mixColor(MyStyle.MDayTransparency, &cFFFFFF, &hB8)
		                gp.DrawRoundRectangle(0, 0, gp.Width, gp.Height, 4, 4)
		                gp.DrawingColor = mixColor(MyStyle.MDayTransparency, &cFFFFFF, &hF)
		                gp.DrawRoundRectangle(0, 0, gp.Width, gp.Height, 6, 6)
		                If MyStyle.MBorderSolid then
		                  gp.DrawingColor = &c0
		                  gp.DrawRoundRectangle(0, 0, gp.Width, gp.Height, 8, 8)
		                  If MyStyle.MDayTransparent then
		                    gp.DrawingColor = MyStyle.MDayTransparency
		                  else
		                    gp.DrawingColor = &c0
		                  End If
		                  gp.FillRoundRectangle(1, 1, gp.Width-2, gp.Height-2, 6, 6)
		                else
		                  If MyStyle.MDayTransparent then
		                    gp.DrawingColor = MyStyle.MDayTransparency
		                  else
		                    gp.DrawingColor = &c0
		                  End If
		                  gp.FillRoundRectangle(0, 0, gp.Width, gp.Height, 8, 8)
		                End If
		                gp.Pixel(1, 1) = &c707070
		                gp.Pixel(gp.Width-2, 1) = &c707070
		                gp.Pixel(1, gp.Height-2) = &c707070
		                gp.Pixel(gp.Width-2, gp.Height-2) = &c707070
		              else
		                gp.DrawingColor = MyStyle.MDayTransparency
		                gp.FillRectangle(0, 0, gp.Width, gp.Height)
		              End If
		              'elseif MyStyle.MDayTransparency <> &c0 then
		              'gp.DrawingColor = mixColor(E.EventColor, &cFFFFFF, MyStyle.MDayTransparency.Red)
		              'gp.FillRectangle(1, 1, gp.Width-2, gp.Height-2)
		            End If
		            
		            //Should go on to the next week line
		            If x + p.Width > gg.Width+5 then
		              
		              Dim remainDays As Integer = RealLength
		              DrawIdx = 0
		              xx = x
		              
		              While remainDays>0
		                DrawEvent(gg, E, xx, y + yy + DayHeight*DrawIdx, _
		                DayWidth * min(7, remainDays) - LeftOffset * 2, MyStyle.MEventHeight, _
		                E.DayEvent)
		                
		                If DrawIdx = 0 then
		                  remainDays = remainDays - (7-Round(x/DayWidth))
		                else
		                  remainDays = remainDays - 7
		                End If
		                
		                xx=MyStyle.MLeftOffset
		                DrawIdx = DrawIdx + 1
		              Wend
		              
		              
		              
		              gp = p.CopyMask.Graphics
		              gp.DrawingColor = &cFFFFFF
		              v = Floor(MyStyle.MEventHeight/2)
		              xx = gg.Width - x
		              RealLength = p.Width
		              While RealLength > 3
		                
		                If RealLength > gg.Width+3 then
		                  For k = 0 to v
		                    gp.DrawLine(xx-(v-k), k, xx+(v-k), k)
		                  Next
		                  For k = v to MyStyle.MEventHeight
		                    gp.DrawLine(xx-(k-v), k, xx+(k-v), k)
		                  Next
		                End If
		                
		                If DrawIdx = 0 then
		                  'gg.DrawPicture(p, x, y + yy, gg.Width-x)
		                  RealLength = RealLength - xx
		                  DeltaX = xx
		                else
		                  'gg.DrawPicture(p, 1, y + yy + DayHeight * DrawIdx, -10000, -10000, DeltaX+1)
		                  RealLength = RealLength - gg.Width
		                  DeltaX = DeltaX + gg.Width
		                End If
		                xx = xx + gg.Width
		                DrawIdx = DrawIdx + 1
		                
		              Wend
		              
		            else
		              //testing
		              DrawEvent(gg, E, x+MyStyle.MLeftOffset, y + yy, _
		              DayWidth * max(1, min(RealLength, 43)) - LeftOffset * 2, MyStyle.MEventHeight, _
		              E.DayEvent)
		              'gg.DrawPicture(p, x+MyStyle.MLeftOffset, y+yy)
		            End If
		            
		            E.drawX = x
		            E.DrawY = y + yy
		            E.DrawW = p.Width
		            E.DrawH = p.Height
		            
		            //Drawing lText
		            gg.DrawingColor = MyStyle.WTextColor
		            If StyleType = StyleOutlook2013 then
		              gg.DrawingColor = mixColor(E.EventColor, &c0, &hB0)
		            else
		              If E.EventColor.Hue = E.EventColor.Saturation then
		                If E.EventColor.Value < 0.5 then
		                  gg.DrawingColor = InvertColor(gg.DrawingColor)
		                End if
		              elseif E.EventColor.Value < 0.9 then
		                gg.DrawingColor = InvertColor(gg.DrawingColor)
		              End If
		            End If
		            gg.FontSize = MyStyle.MEventTextSize
		            gg.Bold = MyStyle.MDayTextBold
		            If E.DayEvent then
		              gg.DrawText(E.Title, x+MyStyle.MTextOffset, y + yy + (MyStyle.MEventHeight-gg.TextHeight)\2 + gg.FontAscent, max(1, E.Length/86400+1) * DayWidth-MyStyle.MTextOffset*2, True)
		            else
		              gg.DrawText(E.StartDate.ToString(DateTime.FormatStyles.None, DateTime.FormatStyles.Short) + " " + E.Title, x+MyStyle.MTextOffset, y + yy + (MyStyle.MEventHeight-gg.TextHeight)\2 + gg.FontAscent, max(1, E.Length/86400+1) * DayWidth-MyStyle.MTextOffset*2, True)
		            End If
		            
		          else //Not a whole day event
		            
		            E.drawX = x
		            E.DrawY = y + yy
		            E.DrawW = DayWidth
		            E.DrawH = MyStyle.MEventHeight
		            
		            //Drawing lText
		            gg.DrawingColor = E.EventColor
		            
		            If MyStyle.MEventFill = FillOutlook2013 then
		              //testing
		              DrawEvent(gg, E, x+MyStyle.MLeftOffset, y + yy, _
		              DayWidth - LeftOffset * 2+1, MyStyle.MEventHeight, False)
		              
		              'p = New Picture(DayWidth - LeftOffset * 2+1, MyStyle.MEventHeight, 32)
		              'gp = p.Graphics
		              'gp.DrawingColor = E.EventColor
		              'gp.FillRectangle(0, 0, 8, gp.Height)
		              'gp.DrawingColor = ShiftColor(E.EventColor, MyStyle.MColorOffset1)
		              'gp.FillRectangle(8, 0, gp.Width, gp.Height)
		              'gg.DrawPicture(p, x+MyStyle.MLeftOffset, y+yy)
		              'gg.DrawingColor = mixColor(E.EventColor, &c0, &hB0)
		            End If
		            
		            gg.FontSize = MyStyle.MEventTextSize
		            gg.Bold = MyStyle.MHourBold
		            lText = E.StartDate.ToString(DateTime.FormatStyles.None, DateTime.FormatStyles.Short) + " "
		            gg.DrawText(lText, x+MyStyle.MTextOffset,y+ yy + (MyStyle.MEventHeight-gg.TextHeight)\2 + gg.FontAscent, DayWidth-MyStyle.MTextOffset*2, True)
		            xx = gg.TextWidth(lText)
		            gg.Bold = MyStyle.MTextBold
		            gg.DrawText(E.Title, x+MyStyle.MTextOffset + xx, y+yy + (MyStyle.MEventHeight-gg.TextHeight)\2 + gg.FontAscent, DayWidth - MyStyle.MTextOffset - xx, True)
		            
		          end if //End of Drawing event
		          
		          
		          
		          'yy = yy + MyStyle.MEventHeight +1
		          
		          
		          
		        elseIf E.Visible = False then //Event doesn't start on that day but we make sure it's space is locked+
		          If E.StartDate.SQLDate < DrawDate.SQLDate and E.EndDate.SQLDate >= DrawDate.SQLDate then
		            Call DrawPos.LockLast((E.StartSeconds - FirstDate.SecondsFrom1970) / 86400, E.Length / 86400)
		            'DrawPos.AddHidden(i, E.Length / 86400)
		          End If
		          
		        End If
		        
		        
		      Next
		      
		      //Drawing the +xx hidden events
		      If DrawPos.Hidden(i) > 0 then
		        gg.FontSize = MyStyle.MEventTextSize
		        gg.DrawingColor = &c0000FF
		        yy = DrawPos.LockLast((DrawDate.SecondsFrom1970 - FirstDate.SecondsFrom1970) / 86400, 0)+1
		        gg.DrawText("+" + str(DrawPos.Hidden(i)), x+MyStyle.MTextOffset, y + yy*(MyStyle.MEventHeight))
		      End If
		      
		      If i mod 7 = 0 then
		        y = y + DayHeight
		        x = 0
		      else
		        x = x + DayWidth
		      End If
		      
		      DrawDate.Day = DrawDate.Day + 1
		    Next
		    
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawEventsWeek(gg As Graphics, DayWidth As Single)
		  'Dim mp As new MethodProfiler(CurrentMethodName)
		  
		  Dim i, j, u, v, Idx, maxAmount As Integer
		  Dim lText As String
		  Dim x, xx,y, yy, w As Single
		  
		  Dim E As CalendarEvent
		  Dim DrawDate As DateTime '= New DateTime
		  'DrawDate.Hour = 0
		  'DrawDate.Minute = 0
		  'DrawDate.Second = 0
		  'DrawDate.SQLDate = FirstDate.SQLDate
		  DrawDate = DateTime.FromString(FirstDate.SQLDate)
		  
		  Dim WholeDay As Boolean
		  Dim FirstJ As Integer
		  Dim okToDraw As Boolean
		  'Dim HasBuffer2 As Boolean
		  
		  
		  Dim Precision as Integer = 12
		  
		  Dim DrawPosDay As New CalendarDrawPosition(ViewDays, (ViewHeight-HeaderHeight-3) / MyStyle.WEventHeight-1)
		  Dim DrawAmountHour As New CalendarDrawPosition(ViewDays*24*Precision, 10)
		  Dim DrawPosHour As New CalendarDrawPosition(ViewDays*24*Precision, 10)
		  
		  Dim gc As Graphics = gg.Clip(0, ViewHeight, gg.Width, gg.Height-ViewHeight)
		  Dim gpc As Graphics
		  
		  Dim gDay As Graphics
		  If DayEventsHeight >-1 then
		    gDay = gg.Clip(0, HeaderHeight+1, gg.Width, DayEventsHeight-4)
		  else
		    gDay = gg.Clip(0, HeaderHeight+1, gg.Width, me.ViewHeight-HeaderHeight-4)
		  End If
		  
		  //Adding DragEvent
		  If SelStart <> Nil and SelEnd <> Nil and (SelStart <> SelEnd or DayEventClicked) then
		    E = New CalendarEvent("", SelStart, SelEnd)
		    E.FrontMost = True
		    E.EventColor = MyColors.WDefaultColor
		    
		    ReDim DisplayEvents(-1)
		    DisplayEvents.Add E
		    SortEvents(FirstDate, LastDate, True)
		  else
		    SortEvents(FirstDate, LastDate)
		  End If
		  
		  //If no events to draw we get out
		  u = DisplayEvents.LastIndex
		  If u =-1 then Return
		  
		  
		  y = ViewHeight
		  x = TimeWidth+1
		  
		  
		  
		  For j = 0 to u
		    E = DisplayEvents(j)
		    //Event is a whole day event
		    If E.DayEvent then
		      
		    ElseIf E.StartDate.Hour = 0 and E.StartDate.Minute = 0 and E.Length mod 86400 = 0 then
		      E.DayEvent = True
		    Else
		      If E.DayEvent then
		        E.DayEvent = False
		      End If
		      Call DrawAmountHour.Search(max(0, (E.StartSeconds - FirstDate.SecondsFrom1970)\(3600/Precision)), (E.EndSeconds-E.StartSeconds)\(3600/Precision)-1)
		    End If
		  Next
		  
		  FirstJ = 0
		  
		  //Cycle all Events to draw
		  For i = 1 to ViewDays
		    y = ViewHeight
		    
		    
		    For j = Idx to u
		      xx = 0
		      
		      //Getting Current Event
		      E = DisplayEvents(j)
		      
		      
		      If E.StartDate.SQLDate > DrawDate.SQLDate then
		        Exit for j
		      elseif E.DayEvent and E.StartDate < DrawDate and i>1 then
		        Idx = Firstj
		        Continue for j
		      elseif E.StartDate < DrawDate and E.EndDate.SQLDate < DrawDate.SQLDate then
		        Idx = Firstj
		        Continue for j
		      elseif E.StartDate < DrawDate and E.EndDate.SQLDate>=DrawDate.SQLDate then
		        'if Keyboard.ControlKey then
		        'idx = idx
		        'end if
		      End If
		      
		      'If E.StartDate.SQLDate = DrawDate.SQLDate or (i=1 and E.StartDate < DrawDate) then //or (E.StartDate < DrawDate and E.EndDate.SQLDate>=DrawDate.SQLDate) then
		      
		      FirstJ = j
		      
		      //Setting up the metrics of the Event
		      
		      //Event is a whole day event
		      If E.DayEvent then
		        WholeDay = true
		        y = HeaderHeight +1
		        
		        If j < u and DisplayEvents(j+1).StartSeconds <= E.EndSeconds and DisplayEvents(j+1).DayEvent _
		          and DrawPosDay.Remain(max(0, (DisplayEvents(j+1).StartSeconds - FirstDate.SecondsFrom1970) / 86400)) < 1 then
		          okToDraw = False
		        else
		          v = DrawPosDay.Remain(max(0, (E.StartSeconds - FirstDate.SecondsFrom1970) / 86400))
		          If v < 1 and DrawPosDay.Hidden(i) > 0 then
		            okToDraw = False
		          elseif v < 0 then
		            okToDraw = False
		          else
		            okToDraw = True
		          End If
		        End If
		        
		        If DayEventsHeight= 0 then
		          okToDraw = False
		        End If
		        
		        If okToDraw then
		          
		          If E.StartDate < DrawDate then
		            w = max(1, min(Floor(E.EndDate.SecondsFrom1970 - DrawDate.SecondsFrom1970) / 86400, ViewDays))
		          else
		            w = max(1, min(ViewDays - (E.StartDate.SecondsFrom1970-FirstDate.SecondsFrom1970)/86400, E.Length/86400+1))
		          End If
		          
		          yy = DrawPosDay.Search(max(0,(E.StartSeconds - FirstDate.SecondsFrom1970) / 86400), w-1) * MyStyle.WEventHeight
		          
		          //Seems this has no use
		          'w = max(0, Ceiling((E.EndDate.SecondsFrom1970 - LastDate.SecondsFrom1970)/86400))
		          
		        else
		          DrawPosDay.AddHidden(i, E.Length/86400)
		          E.Visible = False
		          Continue for j
		        End If
		        
		      else //Not All day event
		        
		        //Finding Y position of the Event
		        If HideNightTime and E.StartDate.Hour >= DayStartHour and E.StartDate.Hour < DayEndHour then
		          y = Ceiling(ViewHeight - (VisibleHours-(gg.Height-ViewHeight)/HourHeight)*HourHeight*ScrollPosition/VisibleHours + (E.StartDate.Hour-DayStartHour+1 + E.StartDate.Minute/60) * Hourheight)
		        elseif not HideNightTime then
		          y = Ceiling(ViewHeight - (VisibleHours-(gg.Height-ViewHeight)/HourHeight)*HourHeight*ScrollPosition/VisibleHours + (E.StartDate.Hour + E.StartDate.Minute/60) * Hourheight)
		        End If
		        
		        If E.StartDate < DrawDate then
		          Dim nbDays As Integer = Ceiling((DrawDate.SecondsFrom1970 - E.StartSeconds)/86400)
		          
		          y = y - HourHeight*24*nbDays
		        End If
		        //A corriger
		        
		        //If Event is out of ViewRange
		        If y + E.Length / 3600 * HourHeight < ViewHeight or y > gg.Height then
		          Continue for j
		        End If
		        
		        
		        WholeDay = False
		        
		        maxAmount = 10-DrawAmountHour.Remain((E.StartSeconds-FirstDate.SecondsFrom1970)\(3600/Precision), E.Length\(3600/Precision))
		        
		        xx = DrawPosHour.Search((E.StartSeconds-FirstDate.SecondsFrom1970)\(3600/Precision), E.Length\(3600/Precision)-1) * DayWidth/maxAmount
		        
		        If E.StartDate<DrawDate then
		          xx = E.DrawX-(X-DayWidth)
		        else
		          E.DrawX = xx
		        End If
		        
		        If not E.FrontMost and maxAmount > 0 then
		          w = (DayWidth-1) / (maxAmount)
		        else
		          w = DayWidth-1
		        End If
		        If E.FrontMost then
		          xx = 0
		        End If
		        
		      end if
		      
		      
		      //Drawing the event and lText
		      If WholeDay then
		        E.DrawX = X
		        E.DrawY = Y + YY
		        E.DrawH = MyStyle.WEventHeight
		        E.DrawW = DayWidth*w
		        
		        
		        //Drawing the Event
		        DrawEvent(gDay, E, x, yy, DayWidth * w, MyStyle.WEventHeight, True)
		        
		        
		        //Drawing lText
		        If MyStyle.WAutoTextColor then
		          gDay.DrawingColor = E.EventColor
		          
		          If E.EventColor.Saturation < 1.0 then
		            gDay.DrawingColor = mixColor(E.EventColor, &c0, &h60)
		          End If
		          
		        else
		          gDay.DrawingColor = MyStyle.WTextColor
		          If E.EventColor.Hue = E.EventColor.Saturation then
		            If E.EventColor.Value < 0.5 then
		              gDay.DrawingColor = InvertColor(gDay.DrawingColor)
		            End if
		          elseif E.EventColor.Value < 0.9 then
		            gDay.DrawingColor = InvertColor(gDay.DrawingColor)
		          End If
		        End If
		        gDay.FontSize = MyStyle.WHeaderTextSize
		        
		        gDay.DrawText(E.Title, x+MyStyle.MTextOffset,  yy + (18-gDay.TextHeight)\2 + gDay.FontAscent, max(1, E.Length/86400+1) * DayWidth -6, True)
		        
		        
		        
		      Else //Not all day
		        
		        If E.StartDate>=DrawDate then
		          E.DrawX = X + XX
		        End If
		        
		        E.DrawY = Y
		        E.DrawW = W
		        E.DrawH = max(HourHeight/2, E.Length / 3600 * HourHeight)
		        
		        
		        y = y-ViewHeight
		        
		        DrawEvent(gc, E, X+XX, Y, Round(w), max(HourHeight/2, E.Length / 3600 * HourHeight), False)
		        
		        gpc = gc.Clip(Floor(X+XX), Y, W, E.DrawH-1)
		        If E.MouseOver and E.Editable then
		          If MyStyle.WAutoTextColor then
		            gpc.DrawingColor = E.EventColor
		          else
		            gpc.DrawingColor = MyStyle.WTextColor
		            If E.EventColor.Hue = E.EventColor.Saturation then
		              If E.EventColor.Value < 0.5 then
		                gpc.DrawingColor = InvertColor(gpc.DrawingColor)
		              End if
		            elseif E.EventColor.Value < 0.9 then
		              gpc.DrawingColor = InvertColor(gpc.DrawingColor)
		            End If
		          End If
		          gpc.DrawLine(E.DrawW\2-3, E.DrawH-5, E.DrawW\2+3, E.DrawH-5)
		          gpc.DrawLine(E.DrawW\2-3, E.DrawH-3, E.DrawW\2+3, E.DrawH-3)
		        End If
		        
		        
		        //Drawing lText
		        If MyStyle.WAutoTextColor then
		          gpc.DrawingColor = E.EventColor
		          
		          If E.EventColor.Saturation < 1.0 then
		            gpc.DrawingColor = mixColor(E.EventColor, &c0, &h60)
		          End If
		          
		        else
		          
		          If StyleType = StyleOutlook2013 then
		            gpc.DrawingColor = mixColor(E.EventColor, &c0, &hB0)
		          else
		            gpc.DrawingColor = MyStyle.WTextColor
		            If E.EventColor.Hue = E.EventColor.Saturation then
		              If E.EventColor.Value < 0.5 then
		                gpc.DrawingColor = InvertColor(gpc.DrawingColor)
		              End if
		            elseif E.EventColor.Value < 0.9 then
		              gpc.DrawingColor = InvertColor(gpc.DrawingColor)
		            End If
		          End If
		        End If
		        gpc.FontSize = MyStyle.WHeaderTextSize
		        gpc.Bold = MyStyle.WHeaderTextBold
		        
		        //Fix Version 1.7
		        If MyStyle.WHeaderHeight > 0 then
		          yy = (MyStyle.WHeaderHeight-gpc.FontSize)/2 + gpc.FontAscent
		        else
		          yy = gpc.FontAscent + 1
		        End If
		        
		        If yy < E.DrawH then
		          lText = MyStyle.WHeaderTextFormat.Replace("%Start", E.StartDate.ToString(DateTime.FormatStyles.None, DateTime.FormatStyles.Short)).Replace("%End", E.EndDate.ToString(DateTime.FormatStyles.None, DateTime.FormatStyles.Short))
		          If lText.IndexOf("%Length")>0 then
		            lText = lText.Replace("%Length", str(Floor(E.Length/3600)) + ":" + Format(E.Length/60 - Floor(E.Length/3600) * 60, "00"))
		          End If
		          If lText <> "" then
		            gpc.DrawText(lText, 1+MyStyle.MTextOffset, yy, w-6, True)
		          End If
		        else
		          gpc.DrawText("...", 1+MyStyle.MTextOffset, E.DrawH - 1)
		          Continue for j
		        End If
		        'End If
		        gpc.FontSize = MyStyle.WBodyTextSize
		        gpc.Bold = MyStyle.WBodyTextBold
		        
		        If lText <> "" then
		          If MyStyle.WHeaderHeight>0 then
		            yy = max(yy+gpc.TextHeight, MyStyle.WHeaderHeight+gpc.TextHeight)
		          else
		            yy = yy + gpc.TextHeight
		          End If
		        End If
		        
		        lText = ""
		        lText = E.Title
		        if E.Location <> "" then
		          lText = lText + " – " + E.Location
		        end if
		        if E.Description <> "" then
		          lText = lText + EndOfLine + E.Description
		        end if
		        
		        
		        gpc.DrawText(lText, 1+MyStyle.MTextOffset, yy, w - 8, False)
		        
		      End If
		      
		      
		      'else
		      '
		      ''Idx = 0
		      'Idx = j
		      'Idx = Firstj
		      '
		      'End If
		      
		    Next
		    
		    //Drawing the +xx hidden events
		    If DrawPosDay.Hidden(i) > 0 and DayEventsHeight <> 0 then
		      gDay.FontSize = MyStyle.WHeaderTextSize
		      gDay.DrawingColor = &c0000FF
		      yy = DrawPosDay.LockLast((DrawDate.SecondsFrom1970 - FirstDate.SecondsFrom1970) / 86400, 0)
		      If yy*(MyStyle.WEventHeight) + gDay.TextHeight < DayEventsHeight then
		        gDay.DrawText("+" + str(DrawPosDay.Hidden(i)), x+MyStyle.MTextOffset, yy*(MyStyle.WEventHeight) + gDay.TextHeight)
		      End If
		    End If
		    
		    
		    x = x + DayWidth
		    'DrawDate.Day = DrawDate.Day + 1
		    DrawDate = DrawDate + DIDay
		    
		  Next
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawEventsWeek_old(gg As Graphics, DayWidth As Single)
		  #Pragma Unused gg
		  #Pragma Unused DayWidth
		  
		  #if False
		    'Dim mp As new MethodProfiler(CurrentMethodName)
		    
		    Dim i, j, u, v, Idx, maxAmount As Integer
		    Dim lText As String
		    Dim x, xx,y, yy, w As Single
		    Dim p As Picture
		    Dim gp As Graphics
		    Dim E As CalendarEvent
		    Dim DrawDate As DateTime '= New DateTime
		    'DrawDate.Hour = 0
		    'DrawDate.Minute = 0
		    'DrawDate.Second = 0
		    'DrawDate.SQLDate = FirstDate.SQLDate
		    DrawDate = DateTime.FromString(FirstDate.SQLDate)
		    Dim WholeDay As Boolean
		    Dim FirstJ As Integer
		    Dim okToDraw As Boolean
		    Dim HasBuffer As Boolean
		    
		    
		    Dim Precision as Integer = 12
		    
		    Dim DrawPosDay As New CalendarDrawPosition(ViewDays, (ViewHeight-HeaderHeight-3) / MyStyle.WEventHeight-1)
		    Dim DrawAmountHour As New CalendarDrawPosition(ViewDays*24*Precision, 10)
		    Dim DrawPosHour As New CalendarDrawPosition(ViewDays*24*Precision, 10)
		    
		    Dim gc As Graphics = gg.Clip(0, ViewHeight, gg.Width, gg.Height-ViewHeight)
		    Dim gpc As Graphics
		    
		    Dim gDay As Graphics
		    If DayEventsHeight >-1 then
		      gDay = gg.Clip(0, HeaderHeight+1, gg.Width, DayEventsHeight-4)
		    else
		      gDay = gg.Clip(0, HeaderHeight+1, gg.Width, me.ViewHeight-HeaderHeight-4)
		    End If
		    
		    //Adding DragEvent
		    If SelStart <> Nil and SelEnd <> Nil and (SelStart <> SelEnd or DayEventClicked) then
		      E = New CalendarEvent("", SelStart, SelEnd)
		      E.FrontMost = True
		      E.EventColor = MyColors.WDefaultColor
		      
		      ReDim DisplayEvents(-1)
		      DisplayEvents.Add E
		      SortEvents(FirstDate, LastDate, True)
		    else
		      SortEvents(FirstDate, LastDate)
		    End If
		    
		    //If no events to draw we get out
		    u = DisplayEvents.LastIndex
		    If u =-1 then Return
		    
		    
		    y = ViewHeight
		    x = TimeWidth+1
		    
		    
		    
		    For j = 0 to u
		      E = DisplayEvents(j)
		      //Event is a whole day event
		      If E.DayEvent then
		        
		      ElseIf E.StartDate.Hour = 0 and E.StartDate.Minute = 0 and E.Length mod 86400 = 0 then
		        E.DayEvent = True
		      Else
		        If E.DayEvent then
		          E.DayEvent = False
		        End If
		        Call DrawAmountHour.Search(max(0, (E.StartSeconds - FirstDate.SecondsFrom1970)\(3600/Precision)), (E.EndSeconds-E.StartSeconds)\(3600/Precision)-1)
		      End If
		    Next
		    
		    FirstJ = 0
		    
		    //Cycle all Events to draw
		    For i = 1 to ViewDays
		      y = ViewHeight
		      
		      
		      For j = Idx to u
		        xx = 0
		        
		        //Getting Current Event
		        E = DisplayEvents(j)
		        HasBuffer = (E.Buffer <> Nil and E.FrontMost=False and E.MouseOver = False)
		        
		        
		        
		        If E.StartDate.SQLDate > DrawDate.SQLDate then
		          Exit for j
		        elseif E.DayEvent and E.StartDate < DrawDate and i>1 then
		          Idx = Firstj
		          Continue for j
		        elseif E.StartDate < DrawDate and E.EndDate.SQLDate < DrawDate.SQLDate then
		          Idx = Firstj
		          Continue for j
		        elseif E.StartDate < DrawDate and E.EndDate.SQLDate>=DrawDate.SQLDate then
		          'if Keyboard.ControlKey then
		          'idx = idx
		          'end if
		        End If
		        
		        'If E.StartDate.SQLDate = DrawDate.SQLDate or (i=1 and E.StartDate < DrawDate) then //or (E.StartDate < DrawDate and E.EndDate.SQLDate>=DrawDate.SQLDate) then
		        
		        FirstJ = j
		        
		        //Event is a whole day event
		        If E.DayEvent then
		          WholeDay = true
		          y = HeaderHeight +1
		          
		          If j < u and DisplayEvents(j+1).StartSeconds <= E.EndSeconds and DisplayEvents(j+1).DayEvent _
		            and DrawPosDay.Remain(max(0, (DisplayEvents(j+1).StartSeconds - FirstDate.SecondsFrom1970) / 86400)) < 1 then
		            okToDraw = False
		          else
		            v = DrawPosDay.Remain(max(0, (E.StartSeconds - FirstDate.SecondsFrom1970) / 86400))
		            If v < 1 and DrawPosDay.Hidden(i) > 0 then
		              okToDraw = False
		            elseif v < 0 then
		              okToDraw = False
		            else
		              okToDraw = True
		            End If
		          End If
		          
		          If DayEventsHeight= 0 then
		            okToDraw = False
		          End If
		          
		          If okToDraw then
		            
		            If E.StartDate < DrawDate then
		              w = max(1, min(Floor(E.EndDate.SecondsFrom1970 - DrawDate.SecondsFrom1970) / 86400, ViewDays))
		            else
		              w = max(1, min(ViewDays - (E.StartDate.SecondsFrom1970-FirstDate.SecondsFrom1970)/86400, E.Length/86400+1))
		            End If
		            If not HasBuffer then
		              p = New Picture(DayWidth * w + 1, MyStyle.WEventHeight, 32)
		            End If
		            
		            yy = DrawPosDay.Search(max(0,(E.StartSeconds - FirstDate.SecondsFrom1970) / 86400), w-1) * MyStyle.WEventHeight
		            
		            //Seems this has no use
		            'w = max(0, Ceiling((E.EndDate.SecondsFrom1970 - LastDate.SecondsFrom1970)/86400))
		            
		          else
		            DrawPosDay.AddHidden(i, E.Length/86400)
		            E.Visible = False
		            Continue for j
		          End If
		          
		        else //Not All day event
		          
		          //Finding Y position of the Event
		          If HideNightTime and E.StartDate.Hour >= DayStartHour and E.StartDate.Hour < DayEndHour then
		            y = Ceiling(ViewHeight - (VisibleHours-(gg.Height-ViewHeight)/HourHeight)*HourHeight*ScrollPosition/VisibleHours + (E.StartDate.Hour-DayStartHour+1 + E.StartDate.Minute/60) * Hourheight)
		          elseif not HideNightTime then
		            y = Ceiling(ViewHeight - (VisibleHours-(gg.Height-ViewHeight)/HourHeight)*HourHeight*ScrollPosition/VisibleHours + (E.StartDate.Hour + E.StartDate.Minute/60) * Hourheight)
		          End If
		          
		          If E.StartDate < DrawDate then
		            Dim nbDays As Integer = Ceiling((DrawDate.SecondsFrom1970 - E.StartSeconds)/86400)
		            
		            y = y - HourHeight*24*nbDays
		          End If
		          //A corriger
		          
		          //If Event is out of ViewRange
		          If y + E.Length / 3600 * HourHeight < ViewHeight or y > gg.Height then
		            Continue for j
		          End If
		          
		          
		          WholeDay = False
		          
		          maxAmount = 10-DrawAmountHour.Remain((E.StartSeconds-FirstDate.SecondsFrom1970)\(3600/Precision), E.Length\(3600/Precision))
		          
		          xx = DrawPosHour.Search((E.StartSeconds-FirstDate.SecondsFrom1970)\(3600/Precision), E.Length\(3600/Precision)-1) * DayWidth/maxAmount
		          
		          If E.StartDate<DrawDate then
		            xx = E.DrawX-(X-DayWidth)
		          else
		            E.DrawX = xx
		          End If
		          
		          If not E.FrontMost and maxAmount > 0 then
		            w = (DayWidth-1) / (maxAmount)
		          else
		            w = DayWidth-1
		          End If
		          If E.FrontMost then
		            xx = 0
		          End If
		          
		          If HasBuffer then
		            If E.Buffer.Width <> Round(w) then
		              HasBuffer = False
		            End If
		          End If
		          
		          If not HasBuffer then
		            p = New Picture(Round(w), max(HourHeight/2, E.Length / 3600 * HourHeight), 32)
		          End If
		          
		        end if
		        
		        If not HasBuffer then
		          gp = p.Graphics
		          
		          //Drawing background color
		          If MyStyle.WRoundRect then //RoundRect
		            
		            
		            If MyStyle.WBodyColorOffset1 = MyStyle.WBodyColorOffset2 then //No gradient
		              gp.DrawingColor = E.EventColor
		              gp.FillRectangle(0, 0, gp.Width, gp.Height)
		              If MyStyle.WHeaderHeight > 0 and not WholeDay then
		                gp.DrawingColor = mixColor(E.EventColor, &cFFFFFF, MyStyle.WHeaderColorOffset)
		                gp.FillRoundRectangle(1, 1, gp.Width-2, 1+MyStyle.WHeaderHeight, 6,6)
		                gp.FillRectangle(1, 1+MyStyle.WHeaderHeight-2, gp.Width-2, 3)
		              End If
		              
		              gp.DrawingColor = mixColor(E.EventColor, &cFFFFFF, MyStyle.WBodyColorOffset1)
		              gp.FillRoundRectangle(1, 1 + MyStyle.WHeaderHeight, gp.Width-2, gp.Height - 2 - MyStyle.WHeaderHeight, 6, 6)
		              gp.FillRectangle(1, 1 + MyStyle.WHeaderHeight, gp.Width-2, 3)
		            else
		              If MyStyle.WBodyGradientVertical then
		                gradient(gp, 1+ MyStyle.WHeaderHeight, gp.Height - 1 - MyStyle.WHeaderHeight, _
		                shiftColor(E.EventColor, MyStyle.WBodyColorOffset1), _
		                ShiftColor(E.EventColor, MyStyle.WBodyColorOffset2), True)
		              else
		                gradient(gp, 1, gp.Width-2, shiftColor(E.EventColor, MyStyle.WBodyColorOffset1), _
		                ShiftColor(E.EventColor, MyStyle.WBodyColorOffset2), False)
		              End If
		              
		              gp.DrawingColor = E.EventColor
		              gp.DrawRectangle(0, 0, gp.Width, gp.Height)
		              gp.DrawRoundRectangle(0, 0, gp.Width, gp.Height, 6,6)
		              gp.DrawRoundRectangle(0, 0, gp.Width, gp.Height, 8,8)
		              If MyStyle.WHeaderHeight > 0 and not WholeDay then
		                gp.DrawingColor = mixColor(E.EventColor, &cFFFFFF, MyStyle.WHeaderColorOffset)
		                gp.FillRoundRectangle(1, 1, gp.Width-2, 1+MyStyle.WHeaderHeight, 6,6)
		                gp.FillRectangle(1, 1+MyStyle.WHeaderHeight-2, gp.Width-2, 3)
		              End If
		            End If
		            
		            'If E.MouseOver and E.Editable then
		            'If MyStyle.WAutoTextColor then
		            'gp.DrawingColor = E.EventColor
		            'else
		            'gp.DrawingColor = MyStyle.WTextColor
		            'If E.EventColor.Hue = E.EventColor.Saturation then
		            'If E.EventColor.Value < 0.5 then
		            'gp.DrawingColor = InvertColor(gp.DrawingColor)
		            'End if
		            'elseif E.EventColor.Value < 0.9 then
		            'gp.DrawingColor = InvertColor(gp.DrawingColor)
		            'End If
		            'End If
		            'gp.DrawLine(gp.Width\2-3, gp.Height-5, gp.Width\2+3, gp.Height-5)
		            'gp.DrawLine(gp.Width\2-3, gp.Height-3, gp.Width\2+3, gp.Height-3)
		            'End If
		            
		            gp = p.CopyMask.Graphics
		            
		            //Drawing picture mask
		            gp.DrawingColor = &cFFFFFF
		            gp.FillRectangle(0, 0, gp.Width, gp.Height)
		            gp.DrawingColor = &cDDDDDD
		            gp.DrawRoundRectangle(0, 0, gp.Width, gp.Height, 4, 4)
		            gp.DrawingColor = &c888888
		            gp.DrawRoundRectangle(0, 0, gp.Width, gp.Height, 6, 6)
		            gp.DrawingColor = &c0
		            gp.DrawRoundRectangle(0, 0, gp.Width, gp.Height, 8, 8)
		            gp.Pixel(1, 1) = &c707070
		            gp.Pixel(gp.Width-2, 1) = &c707070
		            gp.Pixel(1, gp.Height-2) = &c707070
		            gp.Pixel(gp.Width-2, gp.Height-2) = &c707070
		            
		            
		            If MyStyle.WBodyTransparency <> &c0 or MyStyle.WHeaderTransparency <> &c0 then
		              
		              If WholeDay then
		                gp.DrawingColor = MyStyle.WBodyTransparency
		                gp.FillRoundRectangle(1, 1, gp.Width-2, gp.Height-2, 6, 6)
		                
		              Else //not WholeDay
		                
		                If MyStyle.WHeaderHeight > 0  then
		                  gp.DrawingColor = MyStyle.WHeaderTransparency
		                  gp.FillRoundRectangle(1, 1, gp.Width-2, 1+MyStyle.WHeaderHeight, 6,6)
		                  gp.FillRectangle(1, 1+MyStyle.WHeaderHeight-3, gp.Width-2, 3)
		                End If
		                gp.DrawingColor = MyStyle.WBodyTransparency
		                gp.FillRoundRectangle(1, 1+MyStyle.WHeaderHeight, gp.Width-2, gp.Height-2-MyStyle.WHeaderHeight, 6, 6)
		                If MyStyle.WHeaderHeight > 0 then
		                  gp.FillRectangle(1, 1+MyStyle.WHeaderHeight, gp.Width-2, 3)
		                End If
		                
		                'If E.MouseOver and E.Editable then
		                'gp.DrawingColor = &c0
		                'gp.DrawLine(gp.Width\2-3, gp.Height-5, gp.Width\2+3, gp.Height-5)
		                'gp.DrawLine(gp.Width\2-3, gp.Height-3, gp.Width\2+3, gp.Height-3)
		                'End If
		                
		              End If
		            else
		              gp.DrawingColor = &c0
		              gp.FillRoundRectangle(1, 1, gp.Width-2, gp.Height-2, 6, 6)
		            End If
		            
		          Else //not RoundRect
		            
		            If MyStyle.WEventFill = FillSolid then //No gradient
		              gp.DrawingColor = mixColor(E.EventColor, &cFFFFFF, MyStyle.WBodyColorOffset1)
		              gp.FillRectangle(1, 1 + MyStyle.WHeaderHeight, gp.Width-2, gp.Height - 2 - MyStyle.WHeaderHeight)
		            elseif MyStyle.WEventFill = FillGradientVertical then
		              
		              gradient(gp, 1+ MyStyle.WHeaderHeight, gp.Height - 1 - MyStyle.WHeaderHeight, shiftColor(E.EventColor, MyStyle.WBodyColorOffset1), _
		              ShiftColor(E.EventColor, MyStyle.WBodyColorOffset2), True)
		            elseif MyStyle.WEventFill = FillGradientHorizontal Then
		              gradient(gp, 1, gp.Width-2, shiftColor(E.EventColor, MyStyle.WBodyColorOffset1), _
		              ShiftColor(E.EventColor, MyStyle.WBodyColorOffset2), False)
		              
		              //Outlook 2013 Style
		            elseif MyStyle.WEventFill = FillOutlook2013 then
		              gp.DrawingColor = E.EventColor
		              gp.FillRectangle(0, 0, 8, gp.Height)
		              gp.DrawingColor = ShiftColor(E.EventColor, MyStyle.MColorOffset1)
		              gp.FillRectangle(8, 0, gp.Width, gp.Height)
		              If E.DayEvent then
		                gp.DrawingColor = &cFFFFFF
		                gp.FillRectangle(1, 1, 6, gp.Height-2)
		              End If
		            End If
		            
		            //Drawing border
		            If MyStyle.WEventFill <> FillOutlook2013 then
		              gp.DrawingColor = E.EventColor
		              gp.DrawRectangle(0, 0, gp.Width, gp.Height)
		            End If
		            If MyStyle.WHeaderHeight > 0 then
		              gp.DrawingColor = mixColor(E.EventColor, &cFFFFFF, MyStyle.WHeaderColorOffset)
		              gp.FillRectangle(1, 1, gp.Width-2, MyStyle.WHeaderHeight)
		            End If
		            
		            'If E.MouseOver and E.Editable then
		            'If MyStyle.WAutoTextColor then
		            'gp.DrawingColor = E.EventColor
		            'else
		            'gp.DrawingColor = MyStyle.WTextColor
		            'If E.EventColor.Hue = E.EventColor.Saturation then
		            'If E.EventColor.Value < 0.5 then
		            'gp.DrawingColor = InvertColor(gp.DrawingColor)
		            'End if
		            'elseif E.EventColor.Value < 0.9 then
		            'gp.DrawingColor = InvertColor(gp.DrawingColor)
		            'End If
		            'End If
		            'gp.DrawLine(gp.Width\2-3, gp.Height-5, gp.Width\2+3, gp.Height-5)
		            'gp.DrawLine(gp.Width\2-3, gp.Height-3, gp.Width\2+3, gp.Height-3)
		            'End If
		            
		            gp = p.CopyMask.Graphics
		            If MyStyle.WHeaderHeight > 0 and MyStyle.WHeaderTransparency <> &c0 then
		              //Drawing picture mask
		              gp.DrawingColor = MyStyle.WHeaderTransparency
		              gp.FillRectangle(1, 1, gp.Width-2, MyStyle.WHeaderHeight)
		            End If
		            If MyStyle.WBodyTransparency <> &c0 then
		              gp.DrawingColor = MyStyle.WBodyTransparency
		              gp.FillRectangle(1, MyStyle.WHeaderHeight+1, gp.Width-2, gp.Height-MyStyle.WHeaderHeight-2)
		            End If
		            
		            
		            'If E.MouseOver and E.Editable then
		            'gp.DrawingColor = &c0
		            'gp.DrawLine(gp.Width\2-3, gp.Height-5, gp.Width\2+3, gp.Height-5)
		            'gp.DrawLine(gp.Width\2-3, gp.Height-3, gp.Width\2+3, gp.Height-3)
		            'End If
		            
		          End If
		        End If
		        
		        If WholeDay then
		          E.DrawX = X
		          E.DrawY = Y + YY
		          
		          If not HasBuffer then
		            E.Buffer = p
		            E.DrawH = p.Height
		            E.DrawW = p.Width
		          End If
		          If (i mod 7) mod 2 = 1 then
		            //testing
		            DrawEvent(gDay, E, x, yy, DayWidth * w + 1, MyStyle.WEventHeight, True)
		          Else
		            gDay.DrawPicture(E.Buffer, x, yy)
		          End If
		          
		          
		          //Drawing lText
		          If MyStyle.WAutoTextColor then
		            gDay.DrawingColor = E.EventColor
		            
		            If E.EventColor.Saturation < 1.0 then
		              gDay.DrawingColor = mixColor(E.EventColor, &c0, &h60)
		            End If
		            
		          else
		            gDay.DrawingColor = MyStyle.WTextColor
		            If E.EventColor.Hue = E.EventColor.Saturation then
		              If E.EventColor.Value < 0.5 then
		                gDay.DrawingColor = InvertColor(gDay.DrawingColor)
		              End if
		            elseif E.EventColor.Value < 0.9 then
		              gDay.DrawingColor = InvertColor(gDay.DrawingColor)
		            End If
		          End If
		          gDay.FontSize = MyStyle.WHeaderTextSize
		          
		          gDay.DrawText(E.Title, x+MyStyle.MTextOffset,  yy + (18-gDay.TextHeight)\2 + gDay.FontAscent, max(1, E.Length/86400+1) * DayWidth -6, True)
		          
		          
		          
		        Else //Not all day
		          
		          If E.StartDate>=DrawDate then
		            E.DrawX = X + XX
		          End If
		          
		          E.DrawY = Y
		          E.DrawW = W
		          
		          If not HasBuffer then
		            E.Buffer = p
		            E.DrawH = p.Height
		          End If
		          
		          y = y-ViewHeight
		          
		          gpc = gc.Clip(Floor(X+XX), Y, W, E.Buffer.Height-1)
		          If (i mod 7) mod 2 = 1 then
		            //testing
		            DrawEvent(gc, E, X+XX, Y, Round(w), max(HourHeight/2, E.Length / 3600 * HourHeight), False)
		          Else
		            gc.DrawPicture(E.Buffer, X+XX, Y)
		          End If
		          
		          If E.MouseOver and E.Editable then
		            If MyStyle.WAutoTextColor then
		              gpc.DrawingColor = E.EventColor
		            else
		              gpc.DrawingColor = MyStyle.WTextColor
		              If E.EventColor.Hue = E.EventColor.Saturation then
		                If E.EventColor.Value < 0.5 then
		                  gpc.DrawingColor = InvertColor(gpc.DrawingColor)
		                End if
		              elseif E.EventColor.Value < 0.9 then
		                gpc.DrawingColor = InvertColor(gpc.DrawingColor)
		              End If
		            End If
		            gpc.DrawLine(gp.Width\2-3, gp.Height-5, gp.Width\2+3, gp.Height-5)
		            gpc.DrawLine(gp.Width\2-3, gp.Height-3, gp.Width\2+3, gp.Height-3)
		          End If
		          
		          
		          //Drawing lText
		          If MyStyle.WAutoTextColor then
		            gpc.DrawingColor = E.EventColor
		            
		            If E.EventColor.Saturation < 1.0 then
		              gpc.DrawingColor = mixColor(E.EventColor, &c0, &h60)
		            End If
		            
		          else
		            
		            If StyleType = StyleOutlook2013 then
		              gpc.DrawingColor = mixColor(E.EventColor, &c0, &hB0)
		            else
		              gpc.DrawingColor = MyStyle.WTextColor
		              If E.EventColor.Hue = E.EventColor.Saturation then
		                If E.EventColor.Value < 0.5 then
		                  gpc.DrawingColor = InvertColor(gpc.DrawingColor)
		                End if
		              elseif E.EventColor.Value < 0.9 then
		                gpc.DrawingColor = InvertColor(gpc.DrawingColor)
		              End If
		            End If
		          End If
		          gpc.FontSize = MyStyle.WHeaderTextSize
		          gpc.Bold = MyStyle.WHeaderTextBold
		          
		          yy = 11
		          
		          If gpc.TextHeight < E.DrawH then
		            lText = MyStyle.WHeaderTextFormat.Replace("%Start", E.StartDate.ToString(DateTime.FormatStyles.None, DateTime.FormatStyles.Short)).Replace("%End", E.EndDate.ToString(DateTime.FormatStyles.None, DateTime.FormatStyles.Short))
		            If lText.IndexOf("%Length")>0 then
		              lText = lText.Replace("%Length", str(Floor(E.Length/3600)) + ":" + Format(E.Length/60 - Floor(E.Length/3600) * 60, "00"))
		            End If
		            If lText <> "" then
		              gpc.DrawText(lText, 1+MyStyle.MTextOffset, yy, w-6, True)
		              yy = 24
		            End If
		          else
		            gpc.DrawText("...", 1+MyStyle.MTextOffset, E.DrawH - 1)
		            Continue for j
		          End If
		          'End If
		          gpc.FontSize = MyStyle.WBodyTextSize
		          gpc.Bold = MyStyle.WBodyTextBold
		          lText = ""
		          lText = E.Title
		          if E.Location <> "" then
		            lText = lText + " – " + E.Location
		          end if
		          if E.Description <> "" then
		            lText = lText + EndOfLine + E.Description
		          end if
		          
		          
		          gpc.DrawText(lText, 1+MyStyle.MTextOffset, yy, w - 8, False)
		          
		        End If
		        
		        
		        'else
		        '
		        ''Idx = 0
		        'Idx = j
		        'Idx = Firstj
		        '
		        'End If
		        
		      Next
		      
		      //Drawing the +xx hidden events
		      If DrawPosDay.Hidden(i) > 0 and DayEventsHeight <> 0 then
		        gDay.FontSize = MyStyle.WHeaderTextSize
		        gDay.DrawingColor = &c0000FF
		        yy = DrawPosDay.LockLast((DrawDate.SecondsFrom1970 - FirstDate.SecondsFrom1970) / 86400, 0)
		        gDay.DrawText("+" + str(DrawPosDay.Hidden(i)), x+MyStyle.MTextOffset, yy*(MyStyle.WEventHeight) + gDay.TextHeight)
		      End If
		      
		      
		      x = x + DayWidth
		      DrawDate.Day = DrawDate.Day + 1
		    Next
		    
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function DrawHTMLPicker() As String
		  #if TargetWeb
		    Dim Data() As String
		    Dim text, cla, claArr() As String
		    Dim DrawDate, Today As DateTime
		    Dim i, u As Integer
		    Dim onClick As String = " onclick=""Xojo.triggerServerEvent('" + Self.ControlID + "','Click',['%date%']); return false;"" "
		    
		    Dim onClick2 As String = "onclick=""Xojo.triggerServerEvent('" + Self.ControlID + "','ChangeMonth',['%value%']); return false;"" "
		    
		    //Setting FirstDate
		    DrawDate = New DateTime(FirstDate)
		    Today = New DateTime
		    
		    //Month Title
		    text = MonthNames(DisplayDate.Month) + " " + str(DisplayDate.Year)
		    Data.Append "<table cellspacing=""0"" cellpadding=""0"" style=""width:100%;-moz-user-select:none;-webkit-user-select:none;"">"
		    Data.Append "<tbody>"
		    Data.Append "<tr>"
		    cla = " class=""cSt_dp_cell cSt_dp_title"""
		    'If YearSelector then
		    'text = MonthNames(DisplayDate.Month)
		    'Data.Append "<td " + cla + onClick2.Replace("%value%", "-1") + "><</td>"
		    'Data.Append "<td " + cla + " colspan=""2"">" + text + "</td>"
		    'Data.Append "<td " + cla + onClick2.Replace("%value%", "1") + ">></td>"
		    'text = str(DrawDate.Year)
		    'Data.Append "<td " + cla + onClick2.Replace("%value%", "-12") + "><</td>"
		    'Data.Append "<td " + cla + ">" + text + "</td>"
		    'Data.Append "<td " + cla + onClick2.Replace("%value%", "12") + ">></td>"
		    'Else
		    text = MonthNames(DisplayDate.Month) + " " + str(DisplayDate.Year)
		    Data.Append "<td " + cla + onClick2.Replace("%value%", "-1") + "><</td><td " + cla + " colspan=""5"">" + _
		    text + "</td><td " + cla + onClick2.Replace("%value%", "1") + ">></td>"
		    'End If
		    Data.Append "</tr></tbody></table>"
		    
		    //Drawing DayNames
		    Data.Append "<table cellspacing=""0"" cellpadding=""0"" style=""width:100%;-moz-user-select:none;-webkit-user-select:none;"">"
		    Data.Append "<tbody>"
		    Data.Append "<tr>"
		    
		    cla = " class=""cSt_dp_cell cSt_dp_dayName"""
		    
		    For i = 0 to 6
		      If (FirstDayOfWeek + i) = 7 then
		        text = DayNames(7).Titlecase
		      else
		        text = DayNames((FirstDayOfWeek + i) mod 7).Titlecase
		      End If
		      
		      Data.Append "<th " + cla + " title=""" + text + """>" + text.Left(1) + "</th>"
		    Next
		    
		    Data.Append "</tr>"
		    //End of DayNames
		    
		    //DayNumbers
		    
		    u = WeeksPerMonth*7
		    For i = 1 to u
		      If i mod 7 = 1 then
		        Data.Append "<tr style=""cursor:pointer"">"
		      End If
		      text = str(DrawDate.Day)
		      
		      ReDim claArr(-1)
		      
		      claArr.Append "cSt_dp_cell"
		      If DrawDate.Month <> DisplayDate.Month then
		        claArr.Append "cSt_dp_offmonth"
		      else
		        claArr.Append "cSt_dp_onmonth"
		      End If
		      If DrawDate.SQLDate = Today.SQLDate Then
		        claArr.Append "cSt_dp_Today"
		      End If
		      
		      claArr.Append "cSt_dp_dayNbr"
		      
		      If i mod 7 = 1 then
		        claArr.Append "cSt_dp_dayLeft"
		      elseif i mod 7 = 0 then
		        claArr.Append "cSt_dp_dayRight"
		      End If
		      
		      cla = " class=""" + Join(claArr, " ") + """"
		      'If DrawDate.Month <> DisplayDate.month then
		      'cla = " class=""" + self.ControlID + "_dp-cell " + self.ControlID + "_dp-day "+ self.ControlID + "_dp-offmonth """
		      'else
		      'cla = " class=""" + self.ControlID + "_dp-cell " + self.ControlID + "_dp-day "+ self.ControlID + "_dp-onmonth """
		      'End If
		      
		      Data.Append "<td " + cla + onClick.Replace("%date%", DrawDate.SQLDate) + ">" + text + "</td>"
		      
		      If i mod 7 = 0 then
		        Data.Append "</tr>"
		      End If
		      
		      DrawDate.Day = DrawDate.Day+1
		    Next
		    //End of DayNumbers
		    
		    Data.Append "</tbody>"
		    Data.Append "</table>"
		    
		    Return Join(Data, EndOfLine.UNIX)
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function DrawHTMLYear() As String
		  #if TargetWeb
		    Dim Data() As String
		    Dim cla, claArr() As String
		    Dim DrawDate As DateTime
		    Dim i As Integer
		    
		    Dim VAmount As Integer
		    Dim HAmount As Integer
		    //Finding amount of months per line
		    If Width > Height then
		      If Width / Height > 2.45 then
		        HAmount = max(1, Ceiling(YearMonthsAmount/6))
		        VAmount = YearMonthsAmount/HAmount
		        
		      else
		        HAmount = max(1, Ceiling(YearMonthsAmount/4))
		        VAmount = YearMonthsAmount/HAmount
		        
		      End If
		    else
		      If Width / Height < 0.6 then
		        HAmount = max(1, Ceiling(YearMonthsAmount/6))
		        VAmount = YearMonthsAmount/HAmount
		        
		      else
		        HAmount = max(1, Ceiling(YearMonthsAmount/4))
		        VAmount = YearMonthsAmount/HAmount
		        
		      End If
		    End If
		    
		    
		    
		    
		    'Dim MWidth, MHeight As Integer
		    'Dim VGap As Single
		    'Dim HGap As Single
		    
		    
		    
		    'Dim dayWidth As Integer
		    'Dim dayHeight As Integer
		    
		    
		    DrawDate = New DateTime(FirstDate)
		    
		    
		    'dayWidth = Floor((gg.Width-(VAmount-1)*minHGap)/(VAmount*7))
		    'HGap = (gg.Width - 1-dayWidth * VAmount*7)/(VAmount-1)
		    'dayHeight = Floor((gg.Height-(HeaderHeight*HAmount)-minVGap*(HAmount-1))/(6*HAmount))
		    'VGap = (gg.Height-1-HeaderHeight*HAmount-dayHeight*6*HAmount)/(HAmount-1)
		    
		    
		    'MWidth = dayWidth * 7
		    'MHeight = dayHeight * 6
		    
		    
		    
		    
		    
		    //Setting up DayColor for each day in the year
		    If DisplayEvents.LastIndex = -1 then
		      SetDayColor()
		    End If
		    
		    Data.Append "<table width=""100%"" height=""100%""><tr><td>"
		    
		    For i = 1 to mYearMonthsAmount
		      
		      
		      //Drawing Day Numbers and background color for events
		      
		      Data.Append DrawHTMLYearSingle(DrawDate)
		      
		      
		      
		      DrawDate.Day = 1
		      DrawDate.Month = i+1
		      If i < mYearMonthsAmount Then
		        If i mod VAmount = 0 then
		          Data.Append "</td></tr>"
		          Data.Append "<tr><td style=""padding:2px"" colspan=""" + str(HAmount) + """></td></tr>"
		          Data.Append "<tr><td>"
		        else
		          Data.Append "</td>"
		          Data.Append "<td style=""padding:2px""></td>"
		          Data.Append "<td>"
		        End If
		      Else
		        Data.Append "</td></tr>"
		      End If
		    Next
		    
		    Data.Append "</table>"
		    
		    Return Join(Data, EndOfLine.UNIX)
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function DrawHTMLYearSingle(StartDate As DateTime) As String
		  #if TargetDesktop
		    #Pragma Unused StartDate
		    
		  #elseif TargetWeb
		    Dim Data() As String
		    Dim text, cla, claArr(), sty, styArr() As String
		    Dim css As String
		    Dim DrawDate As DateTime
		    Dim i, u As Integer
		    Dim onClick As String = " onclick=""Xojo.triggerServerEvent('" + Self.ControlID + "','Click',['%date%']); return false;"" "
		    
		    Dim onClick2 As String = "onclick=""Xojo.triggerServerEvent('" + Self.ControlID + "','ChangeMonth',['%value%']); return false;"" "
		    
		    css = self.ControlID
		    
		    //Setting FirstDate
		    DrawDate = New DateTime(StartDate)
		    DrawDate.Day = 1
		    DrawDate.Hour = 0
		    DrawDate.Minute = 0
		    DrawDate.Second = 0
		    If DrawDate.DayOfWeek - FirstDayOfWeek <= 0 then
		      DrawDate.Day = DrawDate.Day - (DrawDate.DayOfWeek - FirstDayOfWeek) - 7
		    else
		      DrawDate.Day = DrawDate.Day - (DrawDate.DayOfWeek - FirstDayOfWeek)
		    End If
		    
		    //Container
		    cla = " class=""" + css + "_y_table"""
		    Data.Append "<div " + cla + ">"
		    
		    
		    //Month Title
		    cla = " class="""  + css + "_dp_title"""
		    text = MonthNames(StartDate.Month) + " " + str(StartDate.Year)
		    Data.Append "<p " + cla + " style=""margin-top:2px; margin-bottom:2px; width:100%"">" + text + "</p>"
		    
		    
		    //Drawing DayNames
		    Data.Append "<table cellspacing=""0"" cellpadding=""0"" style=""width:100%;-moz-user-select:none;-webkit-user-select:none;"">"
		    Data.Append "<tbody>"
		    Data.Append "<tr>"
		    
		    cla = " class=""" + css + "_dp_cell " + css + "_dp_dayName"""
		    
		    For i = 0 to 6
		      If (FirstDayOfWeek + i) = 7 then
		        text = DayNames(7).Titlecase
		      else
		        text = DayNames((FirstDayOfWeek + i) mod 7).Titlecase
		      End If
		      
		      Data.Append "<th " + cla + " title=""" + text + """>" + text.Left(1) + "</th>"
		    Next
		    
		    Data.Append "</tr>"
		    //End of DayNames
		    
		    //DayNumbers
		    
		    u = WeeksPerMonth*7
		    For i = 1 to u
		      If i mod 7 = 1 then
		        Data.Append "<tr style=""cursor:pointer"">"
		      End If
		      text = str(DrawDate.Day)
		      
		      ReDim claArr(-1)
		      
		      claArr.Append css + "_dp_cell"
		      If DrawDate.Month <> StartDate.Month then
		        claArr.Append css + "_dp_offmonth"
		      else
		        claArr.Append css + "_dp_onmonth"
		      End If
		      If DrawDate.SQLDate = Today.SQLDate Then
		        claArr.Append css + "_dp_Today"
		      End If
		      
		      claArr.Append css + "_dp_dayNbr"
		      
		      If i mod 7 = 1 then
		        claArr.Append css + "_dp_dayLeft"
		      elseif i mod 7 = 0 then
		        claArr.Append css + "_dp_dayRight"
		      End If
		      
		      cla = " class=""" + Join(claArr, " ") + """"
		      
		      sty = ""
		      If DrawDate.Month = StartDate.Month then
		        
		        If DayColor(DrawDate.DayOfYear) <> Nil then
		          Redim styArr(-1)
		          styArr.Append "background-color: " + FormatColor(DayColor(DrawDate.DayOfYear).FirstColor)
		          
		          
		          If DayColor(StartDate.DayOfYear) <> Nil then
		            If DayColor(StartDate.DayOfYear).FirstColor.Hue = DayColor(StartDate.DayOfYear).FirstColor.Saturation then
		              If DayColor(StartDate.DayOfYear).FirstColor.Value < 0.5 then
		                styArr.Append "color: " + FormatColor(InvertColor(MyColors.DayNumberActive))
		              End if
		              
		            elseif DayColor(StartDate.DayOfYear).FirstColor.Value < 0.9 then
		              styArr.Append "color: " + FormatColor( InvertColor(MyColors.DayNumberActive) )
		            else
		              styArr.Append "color: " + FormatColor( MyColors.DayNumberActive )
		            End If
		          else
		            styArr.Append "color: " + FormatColor( MyColors.DayNumberActive )
		          End If
		          
		          sty = " style=""" + Join(styArr, "; ") + """ "
		          
		        End If
		      End If
		      
		      
		      Data.Append "<td " + cla + sty + onClick.Replace("%date%", DrawDate.SQLDate) + ">" + text + "</td>"
		      
		      If i mod 7 = 0 then
		        Data.Append "</tr>"
		      End If
		      
		      DrawDate.Day = DrawDate.Day+1
		    Next
		    //End of DayNumbers
		    
		    Data.Append "</tbody>"
		    Data.Append "</table>"
		    
		    Return Join(Data, EndOfLine.UNIX)
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawMonthPopup(gg As Graphics, X As Integer, Y As Integer, DayWidth As Integer, DayHeight As Integer)
		  Dim w, i, u, xx, yy As Integer
		  Dim h As Integer = 100
		  Dim D As DateTime
		  'D.Hour = 0
		  'd.Minute = 0
		  'd.Second = 0
		  'd.SQLDate = MonthsPopup.SQLDate
		  D = DateTime.FromString(MonthsPopup.SQLDate)
		  Dim lText As String = d.ToString(DateTime.FormatStyles.Long, DateTime.FormatStyles.None)
		  Dim E As CalendarEvent
		  Dim padding As Integer = 10
		  Dim needsScrollbar As Boolean
		  
		  u = DisplayEvents.LastIndex
		  
		  
		  gg.FontSize = MyStyle.MNumbersTextSize
		  
		  //Normal width
		  w = max(gg.TextWidth(lText)+4 + 20, DayWidth)+padding*2
		  
		  DayWidth = w-padding*2
		  
		  
		  
		  
		  Dim EventList() As CalendarEvent
		  For i = 0 to u
		    If DisplayEvents(i).StartDate.SQLDate = d.SQLDate or _
		      (DisplayEvents(i).StartDate.SecondsFrom1970 <= d.SecondsFrom1970 and _
		      DisplayEvents(i).EndDate.SecondsFrom1970 >= d.SecondsFrom1970) then
		      EventList.Add DisplayEvents(i)
		    End If
		  Next
		  
		  u = EventList.LastIndex
		  
		  //Total height of events
		  h = max(DayHeight, min(17+MyStyle.MNumberYOffset + (MyStyle.MEventHeight +1) * (u+1), gg.Height-padding*2))+padding*2
		  
		  If Y+h > gg.Height then
		    Y = gg.Height-h-1
		    needsScrollbar = True
		    
		    //setting new width
		    Dim eventsInH As Integer = Floor((h-17-MyStyle.MNumberYOffset-MonthsPopup.Yoffset-padding*2)/(MyStyle.MEventHeight+1))
		    w = w + Ceiling(((u+1)/eventsInH)-1.0)*DayWidth
		    
		  End If
		  
		  If X+w > gg.Width then
		    X = gg.Width-w-1
		  End If
		  
		  //Drawing Background
		  gg.DrawingColor = MyColors.WeekDay
		  gg.FillRectangle(X, Y, w, h)
		  
		  //Drawing the Frame
		  gg.DrawingColor = MyColors.Line
		  gg.DrawRectangle(X, Y, w, h)
		  
		  //Drawing date
		  gg.DrawingColor = MyColors.DayNumberActive
		  gg.DrawText(lText, X+2, Y+14+MyStyle.MNumberYOffset)
		  
		  If picCloseMonthPopup <> Nil then
		    gg.DrawPicture(picCloseMonthPopup, X+ w-2-picCloseMonthPopup.Width, Y+ (17-picCloseMonthPopup.Height)\2)
		  End If
		  
		  //Setting the metrics for later use
		  MonthsPopup.Left = X
		  MonthsPopup.Top = Y
		  MonthsPopup.Width = w
		  MonthsPopup.Height = h
		  
		  'If needsScrollbar then
		  'MonthsPopup.Width = MonthsPopup.Width + 10
		  'End If
		  
		  X = X+padding
		  Y = Y+padding
		  
		  Dim gClip As Graphics = gg.Clip(0, Y, gg.Width, gg.Height-Y)
		  
		  Y = MonthsPopup.Yoffset
		  
		  yy = 17 + MyStyle.MNumberYOffset
		  
		  For i = 0 to u
		    E = EventList(i)
		    If E.DayEvent then
		      'DrawEvent(gClip, E, x+MyStyle.MLeftOffset, y + yy, w-padding*2, MyStyle.MEventHeight, E.DayEvent)
		      DrawEvent(gClip, E, x+MyStyle.MLeftOffset, y + yy, DayWidth-padding*2, MyStyle.MEventHeight, E.DayEvent)
		      
		      //Drawing lText
		      gClip.DrawingColor = MyStyle.WTextColor
		      If StyleType = StyleOutlook2013 then
		        gClip.DrawingColor = mixColor(E.EventColor, &c0, &hB0)
		      else
		        If E.EventColor.Hue = E.EventColor.Saturation then
		          If E.EventColor.Value < 0.5 then
		            gClip.DrawingColor = InvertColor(gClip.DrawingColor)
		          End if
		        elseif E.EventColor.Value < 0.9 then
		          gClip.DrawingColor = InvertColor(gClip.DrawingColor)
		        End If
		      End If
		      gClip.FontSize = MyStyle.MEventTextSize
		      gClip.Bold = MyStyle.MDayTextBold
		      If E.DayEvent then
		        gClip.DrawText(E.Title, x+MyStyle.MTextOffset, y + yy + (MyStyle.MEventHeight-gClip.TextHeight)\2 + gClip.FontAscent, DayWidth-MyStyle.MTextOffset, True)
		      else
		        gClip.DrawText(E.StartDate.ToString(DateTime.FormatStyles.None, DateTime.FormatStyles.Short) + " " + E.Title, x+MyStyle.MTextOffset, y + yy + (MyStyle.MEventHeight-gClip.TextHeight)\2 + gClip.FontAscent, max(1, E.Length/86400+1) * DayWidth-MyStyle.MTextOffset*2, True)
		      End If
		      
		    Else //Not a Day event
		      
		      //Drawing lText
		      gClip.DrawingColor = E.EventColor
		      
		      If MyStyle.MEventFill = FillOutlook2013 then
		        //testing
		        DrawEvent(gClip, E, x+MyStyle.MLeftOffset, y + yy, _
		        DayWidth - MyStyle.MLeftOffset * 2+1, MyStyle.MEventHeight, False)
		        
		      End If
		      
		      gClip.FontSize = MyStyle.MEventTextSize
		      gClip.Bold = MyStyle.MHourBold
		      lText = E.StartDate.ToString(DateTime.FormatStyles.None, DateTime.FormatStyles.Short) + " "
		      gClip.DrawText(lText, x+MyStyle.MTextOffset,y+ yy + (MyStyle.MEventHeight-gClip.TextHeight)\2 + gClip.FontAscent, DayWidth-MyStyle.MTextOffset*2, True)
		      xx = gClip.TextWidth(lText)
		      gClip.Bold = MyStyle.MTextBold
		      gClip.DrawText(E.Title, x+MyStyle.MTextOffset + xx, y+yy + (MyStyle.MEventHeight-gClip.TextHeight)\2 + gClip.FontAscent, DayWidth - MyStyle.MTextOffset - xx, True)
		      
		      
		    End If
		    
		    E.drawX = x
		    E.DrawY = y + yy + MonthsPopup.Top + padding
		    E.DrawW = DayWidth
		    E.DrawH = MyStyle.MEventHeight
		    E.Visible = True
		    
		    yy = yy + MyStyle.MEventHeight +1
		    
		    If yy + MyStyle.MEventHeight +1 + padding >= gClip.Height then
		      x = x + DayWidth + 1
		      yy = 17 + MyStyle.MNumberYOffset
		      'Return
		    End If
		  Next
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawPicker(gg As Graphics)
		  //In DebugBuild we check performance of drawing
		  
		  #if DebugBuild
		    Dim ms As Double = System.Microseconds
		  #endif
		  
		  
		  If PickerView = PickerMonth then
		    DrawPickerMonth(gg)
		    Return
		  End If
		  
		  
		  Dim i, u As Integer
		  Dim lText As String
		  Dim x, xx, y As Single
		  Dim DrawDate As DateTime
		  Dim DayWidth As Single = gg.Width / 7
		  Dim DayHeight As Single
		  Dim Pos As Integer
		  Dim Today As DateTime = DateTime.Now
		  Dim HeaderHeight As Integer = 39
		  
		  
		  
		  //Setting FirstDate
		  DrawDate = New DateTime(FirstDate)
		  
		  #if TargetDesktop
		    If mYearPicker <> Nil then
		      mYearPicker.Draw(gg, self)
		      Return
		    End If
		  #endif
		  
		  DayHeight = (gg.Height - HeaderHeight) / WeeksPerMonth
		  
		  If MyStyle.FillGradient then
		    gradient(gg, 0, gg.Height, MyColors.PBackground, MyColors.PBackground2, True)
		  else
		    gg.DrawingColor = MyColors.PBackground
		    gg.FillRectangle(0, 0, gg.Width, gg.Height)
		  End If
		  
		  //Header Background
		  If TransparentBackground then
		    Dim gh As Graphics = gg.Clip(0, 0, gg.Width, HeaderHeight)
		    DrawBackground(gh)
		  else
		    gg.DrawingColor = MyColors.Header
		    If StyleType = StyleOutlook2013 then
		      gg.FillRectangle(0, 0, gg.Width, 22)
		    else
		      gg.FillRectangle(0, 0, gg.Width, HeaderHeight)
		    End If
		  End If
		  
		  
		  y = 22 \ 2
		  
		  #if TargetDesktop
		    If me isa CalendarView then
		  #elseif TargetWeb
		    If me isa WebCalendarView then
		  #endif
		  gg.DrawingColor = MyColors.PArrow
		  
		  
		  If mHiDPI then
		    gg.Pixel(6, y) = gg.DrawingColor
		    gg.Pixel(gg.Width-7, y) = gg.DrawingColor
		    For i = 7 to 14
		      gg.DrawLine(i, y-i+6, i, y+i-6)
		      gg.DrawLine(gg.Width-i-1, y-i+6, gg.Width-i-1, y+i-6)
		    Next
		  else
		    gg.Pixel(5, y) = gg.DrawingColor
		    gg.Pixel(gg.Width-6, y) = gg.DrawingColor
		    For i = 6 to 9
		      gg.DrawLine(i, y-i+5, i, y+i-5)
		      gg.DrawLine(gg.Width-i-1, y-i+5, gg.Width-i-1, y+i-5)
		    Next
		  End If
		  
		  else
		    gg.DrawingColor = MyColors.PArrow
		    gg.Pixel(2, y) = gg.DrawingColor
		    gg.Pixel(gg.Width-3, y) = gg.DrawingColor
		    
		    For i = 3 to 6
		      gg.DrawLine(i, y-i+2, i, y+i-2)
		      gg.DrawLine(gg.Width-i-1, y-i+2, gg.Width-i-1, y+i-2)
		    Next
		  End If
		  
		  
		  //Drawing Month
		  gg.DrawingColor = MyColors.Title
		  gg.Bold = True
		  lText = MonthNames(DisplayDate.Month) + " " + str(DisplayDate.Year)
		  gg.DrawText(lText, (gg.Width-gg.TextWidth(lText))\2, (22-gg.TextHeight)\2 + gg.FontAscent)
		  
		  //Drawing Day names
		  #if TargetDesktop
		    gg.FontSize = 0
		  #elseif TargetWeb
		    gg.FontSize = 12
		  #endif
		  gg.Bold = MyStyle.PDayNameBold
		  If MyStyle.PDayNamePos = 0 then
		    Pos = 0
		    xx = 1
		  elseif MyStyle.PDayNamePos = 1 then
		    Pos = 1
		    xx = 0
		  else
		    Pos = 2
		    xx = 1
		  End If
		  
		  y = 36
		  
		  Dim NameLength As Integer
		  //Finding how many characters can be displayed
		  For i = 0 to 6
		    If (FirstDayOfWeek + i) = 7 then
		      lText = DayNames(7).Titlecase
		    else
		      lText = DayNames((FirstDayOfWeek + i) mod 7).Titlecase
		    End If
		    If gg.TextWidth(lText) < DayWidth-2 then
		      
		    elseif gg.TextWidth(lText.Left(3)) < DayWidth-2 then
		      If NameLength = 0 then
		        NameLength = 3
		      End If
		    elseif gg.TextWidth(lText.Left(2)) < DayWidth-2 then
		      If NameLength = 0 or NameLength = 3 then
		        NameLength = 2
		      End If
		    elseif gg.TextWidth(lText.Left(1)) <=DayWidth-2 then
		      NameLength = 1
		      exit for i
		    End If
		    
		  Next
		  //Drawing day names
		  For i = 0 to 6
		    If (FirstDayOfWeek + i) = 7 then
		      lText = DayNames(7).Titlecase
		    else
		      lText = DayNames((FirstDayOfWeek + i) mod 7).Titlecase
		    End If
		    If NameLength <> 0 then
		      lText = lText.Left(NameLength)
		    End If
		    
		    gg.DrawingColor = MyColors.DayName
		    If Pos = 0 then
		      gg.DrawText(lText, DayWidth * i + xx, y)
		    elseif Pos = 1 then
		      gg.DrawText(lText, DayWidth * i + max(1, (DayWidth - gg.TextWidth(lText)) \ 2), y)
		      
		    else
		      x =DayWidth * i + xx - min(DayWidth-xx, gg.TextWidth(lText))
		      gg.DrawText(lText, DayWidth * i + xx - min(xx-3, gg.TextWidth(lText)), y)
		    End If
		  Next
		  
		  //Drawing day numbers
		  y = 39
		  If MyStyle.PDayNumberPos = 0 then
		    Pos = 0
		    xx = 1
		  elseif MyStyle.PDayNumberPos = 1 then
		    Pos = 1
		    xx = 0
		  else
		    Pos = 2
		    xx = 1
		  End If
		  x = xx
		  u = WeeksPerMonth * 7
		  gg.Bold = MyStyle.PDayNumberbold
		  Dim oktoDraw As Boolean
		  For i = 1 to u
		    
		    //Today Background
		    If DrawDate.SQLDate = Today.SQLDate then
		      gg.DrawingColor = MyColors.Today
		      gg.FillRectangle(x, y, Ceiling(DayWidth), Ceiling(DayHeight))
		      
		      //Selected
		    ElseIf SelStart <> Nil and SelEnd <> nil and DrawDate.SQLDate >= SelStart.SQLDate and DrawDate.SQLDate <= SelEnd.SQLDate then
		      gg.DrawingColor = MyColors.PSelected
		      gg.FillRectangle(x, y, Ceiling(DayWidth), Ceiling(DayHeight))
		      
		      //MouseOver
		    ElseIf i = LastDayOver or (DisplayDate <> Nil and DrawDate.SQLDate = DisplayDate.SQLDate) then
		      gg.DrawingColor = MyColors.POver
		      If StyleType = StyleOutlook2013 then
		        gg.DrawRoundRectangle(x+1, y+1, Ceiling(DayWidth)-2, Ceiling(DayHeight)-2, 2, 2)
		      else
		        gg.FillRectangle(x, y, Ceiling(DayWidth), Ceiling(DayHeight))
		      End If
		    End If
		    
		    If StyleType = StyleOutlook2013 then
		      If i = LastDayOver then
		        gg.DrawingColor = MyColors.POver
		        gg.DrawRoundRectangle(x+1, y+1, Ceiling(DayWidth)-2, Ceiling(DayHeight)-2, 2, 2)
		      End If
		    End If
		    
		    lText = str(DrawDate.Day)
		    
		    
		    If DrawDate.Month <> DisplayDate.Month then
		      If gg.DrawingColor <> MyColors.PDayNumber then
		        gg.DrawingColor = MyColors.PDayNumber
		      End If
		      If MyColors.PDayNumber = MyColors.PBackground then
		        gg.FillRectangle(x, y, Ceiling(DayWidth), Ceiling(DayHeight))
		        oktoDraw = False
		      else
		        oktoDraw = true
		      End If
		    else
		      oktoDraw = true
		      If StyleType = StyleOutlook2013 and DrawDate.SQLDate = Today.SQLDate then
		        gg.DrawingColor = MyColors.PDayNumberToday
		      elseIf gg.DrawingColor <> MyColors.PDayNumberActive then
		        gg.DrawingColor = MyColors.PDayNumberActive
		      End If
		    End If
		    If oktoDraw then
		      If Pos = 0 then
		        gg.DrawText(lText, x, y+(DayHeight-gg.TextHeight)\2 + gg.FontAscent)
		      elseif Pos = 1 then
		        gg.DrawText(lText, x + (DayWidth - gg.TextWidth(lText))\2, y+(DayHeight-gg.TextHeight)\2 + gg.FontAscent)
		      else
		        gg.DrawText(lText, x - gg.TextWidth(lText), y+(DayHeight-gg.TextHeight)\2 + gg.FontAscent)
		      End If
		    End If
		    
		    
		    'DrawDate.Day = DrawDate.Day + 1
		    DrawDate = DrawDate + DIDay
		    If i mod 7 = 0 then
		      y = y + DayHeight
		      x = xx
		    else
		      x = x + DayWidth
		    End If
		  Next
		  
		  If MyStyle.PLineVertical > LineNone then
		    For i = 1 to 6
		      x = DayWidth * i
		      gg.DrawingColor = MyColors.Line
		      If MyStyle.PLineVertical = LineThinSolid then
		        If mHiDPI then
		          gg.FillRectangle(x, 36, 2, gg.Height)
		        else
		          gg.DrawLine(x, 36, x, gg.Height)
		        End If
		      elseif MyStyle.PLineVertical = LineThinDotted then
		        DrawDottedLine(gg, x, 36, x, gg.Height)
		        
		      elseif MyStyle.PLineVertical = LineThinDouble then
		        If mHiDPI then
		          gg.DrawLine(x-2, 36, x-2, gg.Height)
		        End If
		        gg.DrawLine(x-1, 36, x-1, gg.Height)
		        gg.DrawingColor = MyColors.Line2
		        gg.DrawLine(x, 36, x, gg.Height)
		        If mHiDPI then
		          gg.DrawLine(x+1, 36, x+1, gg.Height)
		        End If
		      End If
		    Next
		  End If
		  
		  If Border then
		    gg.DrawingColor = MyColors.Border
		    If TransparentBackground then
		      gg.DrawRectangle(0, HeaderHeight, gg.Width, gg.Height-HeaderHeight)
		      If mHiDPI then
		        gg.DrawRectangle(1, HeaderHeight+1, gg.Width-2, gg.Height-HeaderHeight-2)
		      End If
		    else
		      gg.DrawRectangle(0, 0, gg.Width, gg.Height)
		      If mHiDPI then
		        gg.DrawRectangle(1, 1, gg.Width-2, gg.Height-2)
		      End If
		    End If
		  End If
		  
		  
		  
		  //In DebugBuild we check performance of drawing
		  #if DebugBuild
		    ms = (System.Microseconds-ms)/1000
		    'DrawInfo = str(ms)
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawPickerMonth(gg As Graphics)
		  #if TargetDesktop
		    
		    //In DebugBuild we check performance of drawing
		    #if DebugBuild
		      Dim ms As Double = System.Microseconds
		    #endif
		    
		    Dim i, u As Integer
		    Dim lText As String
		    Dim x, xx, y As Single
		    Dim DrawDate As DateTime
		    Dim DayWidth As Single = gg.Width / 4
		    Dim DayHeight As Single
		    Dim Pos As Integer
		    Dim Today As DateTime = DateTime.Now
		    Dim HeaderHeight As Integer = 39
		    
		    
		    
		    //Setting FirstDate
		    DrawDate = New DateTime(FirstDate.Year,1,1)
		    'DrawDate.Month = 1
		    'DrawDate.Day = 1
		    
		    If mYearPicker <> Nil then
		      mYearPicker.Draw(gg, self)
		      Return
		    End If
		    
		    DayHeight = (gg.Height - HeaderHeight) / 3
		    
		    If MyStyle.FillGradient then
		      gradient(gg, 0, gg.Height, MyColors.PBackground, MyColors.PBackground2, True)
		    else
		      gg.DrawingColor = MyColors.PBackground
		      gg.FillRectangle(0, 0, gg.Width, gg.Height)
		    End If
		    
		    //Header Background
		    If TransparentBackground then
		      Dim gh As Graphics = gg.Clip(0, 0, gg.Width, HeaderHeight)
		      DrawBackground(gh)
		    else
		      gg.DrawingColor = MyColors.Header
		      If StyleType = StyleOutlook2013 then
		        gg.FillRectangle(0, 0, gg.Width, 22)
		      else
		        gg.FillRectangle(0, 0, gg.Width, HeaderHeight)
		      End If
		    End If
		    
		    
		    y = 22 \ 2
		    
		    If me isa CalendarView then
		      gg.DrawingColor = MyColors.PArrow
		      
		      
		      If mHiDPI then
		        gg.Pixel(6, y) = gg.DrawingColor
		        gg.Pixel(gg.Width-7, y) = gg.DrawingColor
		        For i = 7 to 14
		          gg.DrawLine(i, y-i+6, i, y+i-6)
		          gg.DrawLine(gg.Width-i-1, y-i+6, gg.Width-i-1, y+i-6)
		        Next
		      else
		        gg.Pixel(5, y) = gg.DrawingColor
		        gg.Pixel(gg.Width-6, y) = gg.DrawingColor
		        For i = 6 to 9
		          gg.DrawLine(i, y-i+5, i, y+i-5)
		          gg.DrawLine(gg.Width-i-1, y-i+5, gg.Width-i-1, y+i-5)
		        Next
		      End If
		      
		    else
		      gg.DrawingColor = MyColors.PArrow
		      gg.Pixel(2, y) = gg.DrawingColor
		      gg.Pixel(gg.Width-3, y) = gg.DrawingColor
		      
		      For i = 3 to 6
		        gg.DrawLine(i, y-i+2, i, y+i-2)
		        gg.DrawLine(gg.Width-i-1, y-i+2, gg.Width-i-1, y+i-2)
		      Next
		    End If
		    
		    
		    //Drawing Month
		    gg.DrawingColor = MyColors.Title
		    gg.Bold = True
		    lText = str(DisplayDate.Year)
		    gg.DrawText(lText, gg.Width-gg.TextWidth(lText)\2, (22-gg.TextHeight)\2 + gg.FontAscent)
		    
		    //Drawing Day names
		    'gg.FontSize = 0
		    'gg.Bold = MyStyle.PDayNameBold
		    'If MyStyle.PDayNamePos = 0 then
		    'Pos = 0
		    'xx = 1
		    'elseif MyStyle.PDayNamePos = 1 then
		    'Pos = 1
		    'xx = 0
		    'else
		    'Pos = 2
		    'xx = 1
		    'End If
		    '
		    'y = 36
		    '
		    'Dim NameLength As Integer
		    '//Finding how many characters can be displayed
		    'For i = 0 to 6
		    'If (FirstDayOfWeek + i) = 7 then
		    'lText = TitleCase(DayNames(7))
		    'else
		    'lText = TitleCase(DayNames((FirstDayOfWeek + i) mod 7))
		    'End If
		    'If gg.TextWidth(lText) < DayWidth-2 then
		    '
		    'elseif gg.TextWidth(lText.Left(3)) < DayWidth-2 then
		    'If NameLength = 0 then
		    'NameLength = 3
		    'End If
		    'elseif gg.TextWidth(lText.Left(2)) < DayWidth-2 then
		    'If NameLength = 0 or NameLength = 3 then
		    'NameLength = 2
		    'End If
		    'elseif gg.TextWidth(lText.Left(1)) <=DayWidth-2 then
		    'NameLength = 1
		    'exit for i
		    'End If
		    '
		    'Next
		    '//Drawing day names
		    'For i = 0 to 6
		    'If (FirstDayOfWeek + i) = 7 then
		    'lText = TitleCase(DayNames(7))
		    'else
		    'lText = TitleCase(DayNames((FirstDayOfWeek + i) mod 7))
		    'End If
		    'If NameLength <> 0 then
		    'lText = lText.Left(NameLength)
		    'End If
		    '
		    'gg.DrawingColor = MyColors.DayName
		    'If Pos = 0 then
		    'gg.DrawText(lText, DayWidth * i + xx, y)
		    'elseif Pos = 1 then
		    'gg.DrawText(lText, DayWidth * i + max(1, (DayWidth - gg.TextWidth(lText)) \ 2), y)
		    '
		    'else
		    'x =DayWidth * i + xx - min(DayWidth-xx, gg.TextWidth(lText))
		    'gg.DrawText(lText, DayWidth * i + xx - min(xx-3, gg.TextWidth(lText)), y)
		    'End If
		    'Next
		    
		    //Drawing day numbers
		    y = 39
		    If MyStyle.PDayNumberPos = 0 then
		      Pos = 0
		      xx = 1
		    elseif MyStyle.PDayNumberPos = 1 then
		      Pos = 1
		      xx = 0
		    else
		      Pos = 2
		      xx = 1
		    End If
		    x = xx
		    u = 12
		    gg.Bold = MyStyle.PDayNumberbold
		    
		    For i = 1 to u
		      
		      //Today Background
		      If DrawDate.Month = Today.Month then
		        gg.DrawingColor = MyColors.Today
		        gg.FillRectangle(x, y, Ceiling(DayWidth), Ceiling(DayHeight))
		        
		        //Selected
		      ElseIf SelStart <> Nil and SelEnd <> nil and DrawDate.Month >= SelStart.Month and DrawDate.Month <= SelEnd.Month then
		        gg.DrawingColor = MyColors.PSelected
		        gg.FillRectangle(x, y, Ceiling(DayWidth), Ceiling(DayHeight))
		        
		        //MouseOver
		      ElseIf i = LastDayOver or (DisplayDate <> Nil and DrawDate.Month = DisplayDate.Month) then
		        gg.DrawingColor = MyColors.POver
		        If StyleType = StyleOutlook2013 then
		          gg.DrawRoundRectangle(x+1, y+1, Ceiling(DayWidth)-2, Ceiling(DayHeight)-2, 2, 2)
		        else
		          gg.FillRectangle(x, y, Ceiling(DayWidth), Ceiling(DayHeight))
		        End If
		      End If
		      
		      If StyleType = StyleOutlook2013 then
		        If i = LastDayOver then
		          gg.DrawingColor = MyColors.POver
		          gg.DrawRoundRectangle(x+1, y+1, Ceiling(DayWidth)-2, Ceiling(DayHeight)-2, 2, 2)
		        End If
		      End If
		      
		      lText = MonthNames(DrawDate.Month)
		      
		      
		      If StyleType = StyleOutlook2013 and DrawDate.Month = Today.Month and DrawDate.Year = Today.Year then
		        gg.DrawingColor = MyColors.PDayNumberToday
		      elseIf gg.DrawingColor <> MyColors.PDayNumberActive then
		        gg.DrawingColor = MyColors.PDayNumberActive
		      End If
		      
		      If Pos = 0 then
		        gg.DrawText(lText, x, y+(DayHeight-gg.TextHeight)\2 + gg.FontAscent, DayWidth, True)
		      elseif Pos = 1 then
		        gg.DrawText(lText, x + (DayWidth - gg.TextWidth(lText))\2, y+(DayHeight-gg.TextHeight)\2 + _
		        gg.FontAscent, DayWidth, True)
		      else
		        gg.DrawText(lText, x - gg.TextWidth(lText), y+(DayHeight-gg.TextHeight)\2 + gg.FontAscent, _
		        DayWidth, True)
		      End If
		      
		      
		      
		      'DrawDate.Month = DrawDate.Month + 1
		      DrawDate = DrawDate + DIMonth
		      If i mod 4 = 0 then
		        y = y + DayHeight
		        x = xx
		      else
		        x = x + DayWidth
		      End If
		    Next
		    
		    If MyStyle.PLineVertical > LineNone then
		      For i = 1 to 3
		        x = DayWidth * i
		        gg.DrawingColor = MyColors.Line
		        If MyStyle.PLineVertical = LineThinSolid then
		          
		          gg.DrawLine(x, 36, x, gg.Height)
		          
		        elseif MyStyle.PLineVertical = LineThinDotted then
		          DrawDottedLine(gg, x, 36, x, gg.Height)
		          
		        elseif MyStyle.PLineVertical = LineThinDouble then
		          
		          gg.DrawLine(x-1, 36, x-1, gg.Height)
		          gg.DrawingColor = MyColors.Line2
		          gg.DrawLine(x, 36, x, gg.Height)
		          
		        End If
		      Next
		    End If
		    
		    If Border then
		      gg.DrawingColor = MyColors.Border
		      If TransparentBackground then
		        gg.DrawRectangle(0, HeaderHeight, gg.Width, gg.Height-HeaderHeight)
		        
		      else
		        gg.DrawRectangle(0, 0, gg.Width, gg.Height)
		        
		      End If
		    End If
		    
		    
		    
		    //In DebugBuild we check performance of drawing
		    #if DebugBuild
		      ms = (System.Microseconds-ms)/1000
		      'DrawInfo = str(ms)
		    #endif
		    
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawScrollBar(gg As Graphics)
		  Dim visibleh As Integer = Height - ViewHeight
		  'ScrollBarHeight = Visibleh / 24 * visibleh
		  
		  
		  
		  ScrollBarHeight = Visibleh / (HourHeight*VisibleHours) * Visibleh
		  
		  Dim p As Picture
		  Dim gp As Graphics
		  Dim Antialiasing As Boolean
		  #if TargetDesktop
		    If TargetWin32 then 'and not app.UseGDIPlus Then
		      p = New Picture(9, ScrollBarHeight, 32)
		      gp = p.Graphics
		      Antialiasing = False
		    Else
		      'p = New Picture(9, ScrollBarHeight)
		      gp = gg.Clip(Width-9, ViewHeight + (Height-ViewHeight-ScrollBarHeight)*ScrollPosition/24, _
		      9, ScrollBarHeight)
		      Antialiasing = True
		    End If
		  #else
		    'p = New Picture(9, ScrollBarHeight)
		    gp = gg.Clip(Width-9, ViewHeight + (Height-ViewHeight-ScrollBarHeight)*ScrollPosition/24, _
		    9, ScrollBarHeight)
		    Antialiasing = True
		  #endif
		  
		  
		  
		  If Antialiasing Then
		    gp.DrawingColor = &c4D4D4D22
		    gp.FillRoundRectangle(0, 0, gp.Width, gp.Height, 8, 8)
		  Else
		    gp.DrawingColor = &c4D4D4D
		    gp.FillRectangle(0, 0, gp.Width, gp.Height)
		    
		    gp = p.CopyMask.Graphics
		    gp.DrawingColor = &cFFFFFF
		    gp.FillRectangle(0, 0, gp.Width, gp.Height)
		    gp.DrawingColor = mixColor(&c4D4D4D, &cFFFFFF, &hBB)
		    gp.DrawRoundRectangle(0, 0, gp.Width, gp.Height, 4, 4)
		    gp.DrawingColor = mixColor(&c4D4D4D, &cFFFFFF, &h88)
		    gp.DrawRoundRectangle(0, 0, gp.Width, gp.Height, 6, 6)
		    gp.DrawingColor = mixColor(&c4D4D4D, &cFFFFFF, &h22)
		    gp.FillRoundRectangle(1, 1, gp.Width-2, gp.Height-2, 4,4)
		    
		    
		    gg.DrawPicture(p, Width-p.Width, ViewHeight + (Height-ViewHeight-ScrollBarHeight)*ScrollPosition/24)
		    
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawTexture(g As Graphics, Pattern As Picture, Horizontal As Boolean, Vertical As Boolean, Enabled As Boolean = True)
		  
		  If pattern is nil then Return
		  
		  Dim p As Picture = Picture.FromData(Pattern.ToData(Picture.Formats.PNG))
		  
		  If not Enabled then
		    Dim m, x, y As Integer
		    Dim c As Color
		    Dim s As RGBSurface = p.RGBSurface
		    
		    
		    For y = 0 to p.Height-1
		      For x = 0 to p.Width-1
		        c = s.Pixel(x, y)
		        m = (c.red*0.2989)+(c.Green*0.5870)+(c.Blue*0.114)
		        s.Pixel(x, y) = Color.RGB(m, m, m)
		      Next
		    Next
		    
		  End If
		  
		  If p.Width >= g.Width and p.Height >= g.Height then
		    g.DrawPicture(p, 0, 0)
		    
		  Else
		    
		    Dim i, j As Integer
		    Dim w, h, sw, sh As Integer
		    
		    w = g.Width
		    h = g.Height
		    sw = p.Width
		    sh = p.Height
		    
		    If Horizontal and Vertical then
		      
		      For j = 0 to h Step sh
		        For i = 0 to w Step sw
		          g.DrawPicture(p, i, j)
		        Next
		      Next
		      
		    Elseif Horizontal then
		      j = (g.Height-p.Height)\2
		      
		      For i = 0 to w Step sw
		        g.DrawPicture(p, i, j)
		      Next
		      
		    Elseif Vertical then
		      
		      i = (g.Width-p.Width)\2
		      For j = 0 to h Step sh
		        g.DrawPicture(p, i, j)
		      Next
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub DrawTime(gg As Graphics, DayWidth As Single)
		  Dim y As Integer
		  
		  If HideNightTime and (Today.Hour < DayStartHour or Today.Hour > DayEndHour) then Return
		  
		  If HideNightTime then
		    y = ViewHeight - (VisibleHours-(gg.Height-ViewHeight)/HourHeight)*HourHeight*ScrollPosition/VisibleHours+ (Today.Hour-DayStartHour+1) * HourHeight + Today.Minute * HourHeight / 60
		  else
		    y = ViewHeight - (VisibleHours-(gg.Height-ViewHeight)/HourHeight)*HourHeight*ScrollPosition/VisibleHours+ (Today.Hour) * HourHeight + Today.Minute * HourHeight / 60
		  End If
		  If y < ViewHeight-5 then Return
		  y = y - ViewHeight
		  Dim gc As Graphics = gg.Clip(0, ViewHeight, gg.Width, gg.Height-ViewHeight)
		  
		  
		  If StyleType = StyleOutlook2010 then
		    
		    gc.DrawingColor = &cFFD85A
		    gc.DrawLine(0, y-1, TimeWidth-1, y-1)
		    gc.DrawLine(0, y+1, TimeWidth-1, y+1)
		    gc.DrawingColor = &cEB8900
		    gc.DrawLine(0, y, TimeWidth-1, y)
		    
		  elseif StyleType = StyleOutlook2013 then
		    gc.DrawingColor = &cB1D6F0
		    gc.DrawLine(0, y-1, Width, y-1)
		    gc.DrawLine(0, y+1, Width, y+1)
		    gc.DrawingColor = &c2A8DD4
		    gc.DrawLine(0, y, Width, y)
		    
		  else
		    gc.DrawingColor = &cFF7F6E
		    
		    If Today.SecondsFrom1970 >= FirstDate.SecondsFrom1970 and Today.SecondsFrom1970 <= LastDate.SecondsFrom1970 then
		      If mHiDPI then
		        gc.DrawingColor = ShiftColor(gc.DrawingColor, 20)
		        gc.FillRectangle(TimeWidth + (Today.Day-FirstDate.Day) * DayWidth, y, Ceiling(DayWidth)-1, 4)
		        gc.DrawingColor = &cFF7F6E
		        gc.FillRectangle(TimeWidth + (Today.Day-FirstDate.Day) * DayWidth, y+1, Ceiling(DayWidth)-1, 2)
		      else
		        gc.FillRectangle(TimeWidth + (Today.Day-FirstDate.Day) * DayWidth, y, Ceiling(DayWidth), 2)
		      End If
		    End If
		    
		    Dim start As Integer
		    If Border then
		      If mHiDPI then
		        start = 2
		      else
		        start = 1
		      End If
		    End If
		    For i as Integer = start to 3+start
		      gc.DrawLine(i, y-((3+start)-i), i, y+((3+start)-i))
		    Next
		    
		    If y >-1 and y < gc.Height then
		      gc.Pixel(3+start, y) = gc.DrawingColor
		    End If
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub EraseBuffers()
		  #if False
		    //Erasing all buffers
		    Dim i, u As Integer
		    u = Events.LastIndex
		    For i = 0 to u
		      If Events(i).Buffer <> Nil then
		        Events(i).Buffer = Nil
		      End If
		    Next
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function EventForXY(X As Integer, Y As Integer, RemoveMouseOver As Boolean = False) As CalendarEvent
		  If X=-1 or Y=-1 then
		    Return Nil
		  End If
		  
		  If ViewType = TypeYear or ViewType = TypePicker then
		    Return Nil
		  End If
		  
		  Dim i, u As Integer
		  u = DisplayEvents.LastIndex
		  Dim E As CalendarEvent
		  Dim Found As Boolean
		  Dim FoundI As Integer = -1
		  
		  If DragEvent > 0 then
		    x =x
		  End If
		  
		  For i = u DownTo 0
		    
		    E = DisplayEvents(i)
		    If RemoveMouseOver and E.MouseOver then
		      E.MouseOver = False
		    End If
		    
		    If not Found then
		      If X>=E.DrawX and X < E.DrawX + E.DrawW and Y >= E.DrawY and Y < E.DrawY + E.DrawH then
		        Found = True
		        FoundI = i
		      End If
		    End If
		  Next
		  
		  If FoundI > -1 then
		    Return DisplayEvents(FoundI)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ExportAsPicture() As Picture
		  Dim r() As Xojo.Rect
		  Dim p As Picture = New Picture(Width, Height, 32)
		  
		  handlePaint(p.Graphics, r())
		  
		  Return p
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ExportICS() As String
		  //Exports all CalendarEvents in ICS (iCal) format
		  
		  Dim Line() As String
		  Dim i, u As Integer
		  u = Events.LastIndex
		  If u = -1 then Return ""
		  Dim Time As String
		  Dim E As CalendarEvent
		  
		  Line.Add "BEGIN:VCALENDAR"
		  Line.Add "VERSION:2.0"
		  Line.Add "PRODID:XOJO CalendarView"
		  
		  For i = 0 to u
		    E = Events(i)
		    
		    Line.Add "BEGIN:VEVENT"
		    
		    If E.Length mod 86400 <> 0 then
		      Time = E.StartDate.SQLDateTime.ReplaceAll("-", "").Replace(" ", "T").ReplaceAll(":", "")
		      'If E.StartDate.GMTOffset = 0 then
		      If E.StartDate.Timezone.SecondsFromGMT = 0 then
		        Time = Time + "Z"
		      End If
		    else
		      Time = E.StartDate.SQLDate.ReplaceAll("-", "")
		    End If
		    
		    Line.Add "DTSTART:" + Time
		    
		    //Length
		    If E.Length <> 0 then
		      If E.Length mod 86400 <> 0 then
		        Time = E.EndDate.SQLDateTime.ReplaceAll("-", "").Replace(" ", "T").ReplaceAll(":", "")
		        If E.EndDate.Timezone.SecondsFromGMT = 0 then
		          Time = Time + "Z"
		        End If
		      else
		        Time = E.EndDate.SQLDate.ReplaceAll("-", "")
		      End If
		      Line.Add "DTEND:" + Time
		    End If
		    
		    //Text information
		    Line.Add "SUMMARY:" + E.Title
		    If E.Location <> "" then
		      Line.Add "LOCATION:" + E.Location
		    End If
		    If E.Description <> "" then
		      Line.Add "DESCRIPTION:" + E.Description
		    End If
		    
		    //Recurrence
		    If E.Recurrence <> Nil then
		      Line.Add "RRULE:" + E.Recurrence.ToICS(E)
		    End If
		    
		    Line.Add "UID:" + E.ID
		    Line.Add "X-RSCV-COLOR:" + FormatColor(E.EventColor)
		    Line.Add "X-RSCV-TAG:" + E.Tag.StringValue
		    Line.Add "END:VEVENT"
		  Next
		  
		  
		  
		  
		  
		  
		  
		  Line.Add "END:VCALENDAR"
		  
		  
		  Return String.FromArray(Line,EndOfLine)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ExportToDB(DB As Database, TableName As String, ID As String = "ID", StartDate As String = "Start", EndDate As String = "End", Title As String = "Title", EventColor As String = "Color", Location As String = "Location", Description As String = "Description", Recurrence As String = "Recurrence") As Boolean
		  //Exports all CalendarEvents to the passed TableName in the passed Database.
		  
		  If DB is Nil then
		    System.DebugLog(CurrentMethodName + " DB is Nil")
		    Return False
		  End If
		  
		  Try
		    db.Connect
		  Catch dbe As DatabaseException
		    System.DebugLog(CurrentMethodName + " DB.Connect failed")
		    Return False
		  End Try
		  
		  Dim Rec As DatabaseRow
		  Dim cEvent As CalendarEvent
		  Dim i As Integer
		  Dim maxID As String
		  Dim RS As RowSet
		  Dim wSQL As String
		  
		  For i = 0 to DeletedIDs.LastIndex
		    Try
		      DB.ExecuteSQL("DELETE FROM " + TableName + " WHERE " + ID + "='" + DeletedIDs(i) + "'")
		    Catch dbe As DatabaseException
		      System.DebugLog(CurrentMethodName + " - DB has error while deleting - " + dbe.Message)
		      Return False
		    End Try
		  Next
		  
		  
		  //Finding the maximum ID
		  Try
		    RS = DB.SelectSQL("SELECT " + ID + " FROM " + TableName + " ORDER BY " + ID + " DESC LIMIT 0,1")
		  Catch dbe As DatabaseException
		    System.DebugLog(CurrentMethodName + " - DB has error finding max id - " + dbe.Message)
		    Return False
		  End Try
		  
		  If RS <> Nil then
		    If RS.RowCount > 0 then
		      maxID = RS.ColumnAt(1)
		    else
		      maxID = "0"
		    End If
		  else
		    maxID = "0"
		  End If
		  
		  For i = 0 to Events.LastIndex
		    cEvent = Events(i)
		    
		    If cEvent.ID <> "" and cEvent.ID.left(4) <> "auto" then
		      wSQL = "SELECT " + StartDate + "," + Title
		      If EndDate <> "" then
		        wSQL = wSQL + "," + EndDate
		      End If
		      If EventColor <> "" then
		        wSQL = wSQL + "," + EventColor
		      End If
		      If Location <> "" then
		        wSQL = wSQL + "," + Location
		      End If
		      If Description <> "" then
		        wSQL = wSQL + "," + Description
		      End If
		      If Recurrence <> "" then
		        wSQL = wSQL + "," + Recurrence
		      End If
		      
		      wSQL = wSQL + " FROM " + TableName + " WHERE " + ID + "=" + cEvent.ID
		      
		      Try
		        RS = DB.SelectSQL(wSQL)
		      Catch dbe As DatabaseException
		        System.DebugLog(CurrentMethodName + " - DB has error on select - " + dbe.Message)
		        Return False
		      End Try
		      
		    End If
		    If cEvent.ID <> "" and cEvent.ID.left(4) <> "auto" and RS <> Nil and RS.RowCount > 0 then
		      
		      RS.EditRow()
		      
		      RS.Column(StartDate).Value = cEvent.StartDate.SQLDateTime
		      RS.Column(EndDate).Value = cEvent.EndDate.SQLDateTime
		      RS.Column(Title).StringValue = cEvent.Title
		      RS.Column(EventColor).StringValue = FormatColor(cEvent.EventColor)
		      RS.Column(Location).StringValue = cEvent.Location
		      RS.Column(Description).StringValue = cEvent.Description
		      If cEvent.Recurrence <> Nil then
		        RS.Column(Recurrence).StringValue = cEvent.Recurrence.ToICS(cEvent)
		      End If
		      
		      Try
		        RS.SaveRow
		      Catch dbe As DatabaseException
		        System.DebugLog(CurrentMethodName + " - DB has error before Commit - " + dbe.Message)
		        Return False
		      End Try
		      
		    else
		      
		      maxID = str(val(maxID) + 1)
		      
		      cEvent.ID = maxID
		      
		      rec = New DatabaseRow
		      rec.Column(ID) = cEvent.ID
		      rec.Column(StartDate) = cEvent.StartDate.SQLDateTime
		      If EndDate <> "" then
		        rec.Column(EndDate) = cEvent.EndDate.SQLDateTime
		      End If
		      rec.Column(Title) = cEvent.Title
		      rec.Column(EventColor) = FormatColor(cEvent.EventColor)
		      If Location <> "" then
		        rec.Column(Location) = cEvent.Location
		      End If
		      If Description <> "" then
		        rec.Column(Description) = cEvent.Description
		      End If
		      If cEvent.Recurrence <> Nil and Recurrence <> "" then
		        rec.Column(Recurrence) = cEvent.Recurrence.ToICS(cEvent)
		      End If
		      
		      Try
		        db.AddRow TableName, Rec
		      Catch dbe As DatabaseException
		        System.DebugLog(CurrentMethodName + " - DB has error before Commit - " + dbe.Message)
		        Return False
		      End Try
		    End If
		    
		    Try
		      db.CommitTransaction
		    Catch dbe As DatabaseException
		      System.DebugLog(CurrentMethodName + " DB has error after Commit")
		      Return False
		    End Try
		    
		  Next
		  
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function FindScreen() As Integer
		  #if TargetDesktop
		    Dim w As DesktopWindow = self.Window
		    
		    For i as Integer = 0 to ScreenCount-1
		      
		      If w.Left >=Screen(i).Left and w.left <= Screen(i).Left + Screen(i).Width then
		        
		        If w.Top >= Screen(i).top and w.top <=Screen(i).Top + Screen(i).Height then
		          
		          Return i
		          
		        End If
		      End If
		    Next
		    
		    Return 0
		    
		    Dim Percent As Integer
		    For i as Integer = 0 to ScreenCount-1
		      
		      If w.left > Screen(i).left + Screen(i).Width then
		        Continue
		      End If
		      
		      If w.top > Screen(i).Top + Screen(i).Height then
		        Continue
		      End If
		      
		      Percent = w.Left + w.Width
		      
		      If w.Left >=Screen(i).Left and w.left <= Screen(i).Left + Screen(i).AvailableWidth then
		        
		        If w.Top >= Screen(i).Left and w.top <=Screen(i).Top + Screen(i).AvailableHeight then
		          
		          Return i
		          
		        End If
		      End If
		    Next
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FocusOn(cEvent As CalendarEvent)
		  //newinversion 1.4.0
		  //Goes to the current date of the passed cEvent.
		  
		  
		  //If Animate is True, 
		  
		  If cEvent is Nil then raise new NilObjectException
		  
		  If me.ViewType = me.TypeOther and ViewDays = 5 and (cEvent.StartDate.DayOfWeek=1 or cEvent.StartDate.DayOfWeek=7) then
		    //For sundays and saturdays we change the amount of days to display or else the event will never be displayed.
		    me.ViewDays = 7
		  End If
		  DisplayDate = cEvent.StartDate
		End Sub
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
		Function GetEvents() As CalendarEvent()
		  //Retrieves all CalendarEvents from the CalendarView
		  
		  Redim DisplayEvents(-1)
		  Return Events()
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetLocaleInfo(type as Integer, mb as MemoryBlock, ByRef retVal as String) As Integer
		  #if TargetWin32
		    
		    Dim LCID As Integer = &H400
		    
		    Soft Declare Function GetLocaleInfoA Lib "kernel32" (Locale As integer, LCType As integer, lpLCData As ptr, cchData As integer) As Integer
		    Soft Declare Function GetLocaleInfoW Lib "kernel32" (Locale As integer, LCType As integer, lpLCData As ptr, cchData As integer) As Integer
		    
		    dim returnValue as Integer
		    dim size as Integer
		    
		    if mb <> nil then size = mb.Size
		    
		    if System.IsFunctionAvailable( "GetLocaleInfoW", "Kernel32" ) then
		      if mb <> nil then
		        returnValue = GetLocaleInfoW( LCID, type, mb, size ) * 2
		        retVal = DefineEncoding( mb.StringValue( 0, returnValue ), Encodings.UTF16 ).ReplaceAll( Chr( 0 ), "" )
		      else
		        returnValue = GetLocaleInfoW( LCID, type, nil, size ) * 2
		      end if
		    else
		      if mb <> nil then
		        returnValue = GetLocaleInfoA( LCID, type, mb, size ) * 2
		        retVal = DefineEncoding( mb.StringValue( 0, returnValue ), Encodings.ASCII ).ReplaceAll( Chr( 0 ), "" )
		      else
		        returnValue = GetLocaleInfoA( LCID, type, nil, size ) * 2
		      end if
		    end if
		    
		    return returnValue
		    
		  #else
		    #Pragma Unused type
		    #Pragma Unused mb
		    #Pragma Unused retVal
		  #endif
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function getTimeTextForWeek(text As String, Hour As Integer, StartHour As Integer, DrawDate As DateTime) As String
		  
		  Dim HiddenHour As Boolean
		  
		  If HideNightTime then
		    If Hour = StartHour and DayStartHour>0 then
		      HiddenHour = True
		    elseif DayEndHour>0 and Hour = VisibleHours then
		      HiddenHour = True
		    End If
		  End If
		  
		  
		  If MyStyle.WTimeFormat.IndexOf("(a)")>0 then
		    
		    If HiddenHour then
		      Dim mText As String = text
		      text = ParseTime(DrawDate, mtext) + " - "
		      If Hour = StartHour then
		        'DrawDate.Hour = DayStartHour
		        DrawDate = DrawDate - New DateInterval(0,0,DrawDate.Hour,drawdate.Minute) + New DateInterval(0,0,0,DayStartHour)
		      elseif Hour = VisibleHours then
		        'DrawDate.Hour = 0
		        DrawDate = DrawDate - New DateInterval(0,0,DrawDate.Hour,drawdate.Minute) 
		      End If
		      text = text + ParseDate(DrawDate, mText)
		    Else
		      text = ParseTime(DrawDate, text)
		    End If
		    
		  else
		    
		    If ForceAM_PM or DrawDate.ToString(DateTime.FormatStyles.None, DateTime.FormatStyles.Short).IndexOf("am")>0 or DrawDate.ToString(DateTime.FormatStyles.None, DateTime.FormatStyles.Short).IndexOf("pm")>0 then
		      If HiddenHour then
		        text = ParseTime(DrawDate, MyStyle.WTimeFormat, "HH ") + " - "
		        If Hour = StartHour then
		          'DrawDate.Hour = DayStartHour
		          DrawDate = DrawDate - New DateInterval(0,0,DrawDate.Hour,drawdate.Minute) + New DateInterval(0,0,0,DayStartHour)
		        elseif Hour = VisibleHours then
		          'DrawDate.Hour = 0
		          DrawDate = DrawDate - New DateInterval(0,0,DrawDate.Hour,drawdate.Minute) 
		        End If
		        text = text + ParseTime(DrawDate, MyStyle.WTimeFormat, "HH ")
		      Else
		        text = ParseTime(DrawDate, MyStyle.WTimeFormat, "HH ")
		      End If
		      
		    else
		      If HiddenHour then
		        text = ParseTime(DrawDate, MyStyle.WTimeFormat, "HH:MM") + " - "
		        If Hour = StartHour then
		          'DrawDate.Hour = DayStartHour
		          DrawDate = DrawDate - New DateInterval(0,0,DrawDate.Hour,drawdate.Minute) + New DateInterval(0,0,0,DayStartHour)
		        elseif Hour = VisibleHours then
		          'DrawDate.Hour = 0
		          DrawDate = DrawDate - New DateInterval(0,0,DrawDate.Hour,drawdate.Minute) 
		        End If
		        text = text + ParseTime(DrawDate, MyStyle.WTimeFormat, "HH:MM")
		      Else
		        text = ParseTime(DrawDate, MyStyle.WTimeFormat, "HH:MM")
		      End If
		    End If
		  End If
		  
		  Return Text
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetWindowColor() As Color
		  #if TargetDesktop
		    #if RBVersion>2009 then
		      If me.Window.HasBackgroundColor then
		        Return me.Window.BackgroundColor
		    #else
		      If me.Window.HasBackgroundColor then
		        Return me.Window.BackgroundColor
		    #endif
		    Else
		      #if TargetMacOS
		        //A corriger?
		        Return &cF0F0F0
		        Return &cE8E8E8
		      #else
		        Return Color.FillColor()
		      #endif
		    End If
		    
		  #Endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub gradient(g as graphics, Start as integer, Length as integer, startColor as color, endColor as color, Vertical As Boolean = True, Alpha As Integer = 0)
		  //modified gradient code, original code: Seth Willits
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  
		  dim i as integer, ratio, endratio as Single
		  Dim calcAlpha As Boolean
		  
		  If length = 0 then
		    Return
		  End If
		  
		  #if TargetDesktop
		    If TargetWin32 then 'and App.UseGDIPlus=False) then
		      Alpha = 0
		    Else
		      If startColor.Alpha <> 0 or endColor.Alpha<>0 then
		        calcAlpha = True
		      End If
		    End If
		  #elseif TargetWeb
		    If startColor.Alpha <> 0 or endColor.Alpha <> 0 then
		      calcAlpha = True
		    End If
		  #endif
		  
		  // Draw the gradient
		  for i = start to start + length
		    
		    // Determine the current line's color
		    ratio = ((length-(i-start))/length)
		    
		    
		    endratio = ((i-start)/length)
		    If calcAlpha then
		      g.DrawingColor = Color.RGB(EndColor.Red * endratio + StartColor.Red * ratio, EndColor.Green * endratio +_
		      StartColor.Green * ratio, EndColor.Blue * endratio + StartColor.Blue * ratio, endColor.Alpha * endratio + startColor.Alpha * ratio)
		    else
		      g.DrawingColor = Color.RGB(EndColor.Red * endratio + StartColor.Red * ratio, EndColor.Green * endratio +_
		      StartColor.Green * ratio, EndColor.Blue * endratio + StartColor.Blue * ratio, Alpha)
		    End If
		    
		    // Draw the step
		    If Vertical then
		      g.DrawLine 0, i, g.Width, i
		      
		    Else
		      g.DrawLine i, 0, i, g.Height
		    End If
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub gradient2(g as graphics, X As Integer, Y As Integer, Width As Integer, Height As Integer, startColor as color, endColor as color, Vertical As Boolean = True, Alpha As Integer = 0, Special As Integer = 0)
		  //modified gradient code, original code: Seth Willits
		  #pragma DisableBackgroundTasks
		  #pragma DisableBoundsChecking
		  #Pragma Unused Special
		  
		  //Special:
		  //Value 1 the gradient makes a triangle at the left
		  //Value 2 the gradient makes a triangle at the right
		  //Value 3 triangle on both sides
		  
		  Dim gg As Graphics = g.Clip(X, Y, Width, Height)
		  
		  dim i as integer, ratio, endratio as Single
		  Dim calcAlpha As Boolean
		  Dim Start, Length As Integer
		  
		  Start = 0
		  If Vertical then
		    Length = gg.Height-1
		  Else
		    Length = gg.Width-1
		  End If
		  
		  If length = 0 then
		    Return
		  End If
		  
		  #if TargetDesktop
		    If TargetWin32 then 'and App.UseGDIPlus=False) then
		      Alpha = 0
		    Else
		      If startColor.Alpha <> 0 or endColor.Alpha<>0 then
		        calcAlpha = True
		      End If
		    End If
		  #elseif TargetWeb
		    If startColor.Alpha <> 0 or endColor.Alpha <> 0 then
		      calcAlpha = True
		    End If
		  #endif
		  
		  // Draw the gradient
		  for i = start to start + length
		    
		    // Determine the current line's color
		    ratio = ((length-(i-start))/length)
		    
		    
		    endratio = ((i-start)/length)
		    If calcAlpha then
		      gg.DrawingColor = Color.RGB(EndColor.Red * endratio + StartColor.Red * ratio, EndColor.Green * endratio +_
		      StartColor.Green * ratio, EndColor.Blue * endratio + StartColor.Blue * ratio, endColor.Alpha * endratio + startColor.Alpha * ratio)
		    else
		      gg.DrawingColor = Color.RGB(EndColor.Red * endratio + StartColor.Red * ratio, EndColor.Green * endratio +_
		      StartColor.Green * ratio, EndColor.Blue * endratio + StartColor.Blue * ratio, Alpha)
		    End If
		    
		    // Draw the step
		    If Vertical then
		      gg.DrawLine 0, i, g.Width, i
		      
		    Else
		      gg.DrawLine i, 0, i, g.Height
		    End If
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub HandleDragEvent(X As Integer, Y As Integer)
		  Dim tmpDate As DateTime = DateForXY(X, Y)
		  
		  If LastMouseOver is Nil then Return
		  
		  If tmpDate <> Nil then
		    
		    If DragEvent = DragResize then
		      'tmpDate.SQLDate = LastMouseOver.StartDate.SQLDate
		      
		      If LastMouseOver.StartSeconds <= tmpDate.SecondsFrom1970  then
		        
		        If LastMouseOver.StartDate.Hour = tmpDate.Hour and LastMouseOver.StartDate.Minute = tmpDate.Minute then
		          'LastMouseOver.EndDate.Hour = LastMouseOver.StartDate.Hour
		          'LastMouseOver.EndDate.Minute = LastMouseOver.StartDate.Minute + 15
		          LastMouseOver.EndDate = LastMouseOver.EndDate - New DateInterval(0,0,LastMouseOver.EndDate.Hour,LastMouseOver.EndDate.Minute) + New DateInterval(0,0,0,LastMouseOver.StartDate.Hour,LastMouseOver.StartDate.Minute+15)
		        else
		          'LastMouseOver.EndDate.SecondsFrom1970 = tmpDate.SecondsFrom1970
		          LastMouseOver.EndDate = New DateTime(tmpDate)
		          'LastMouseOver.EndDate.Hour = tmpDate.Hour
		          'LastMouseOver.EndDate.Minute = tmpDate.Minute
		          'LastMouseOver.EndDate.Month = tmpDate.Month
		          'LastMouseOver.EndDate.Day = tmp
		        End If
		        DragEvent(LastMouseOver)
		        Redisplay()
		        
		      End If
		      
		    elseif DragEvent = DragMove then
		      
		      Dim lastStart As Double = LastMouseOver.StartSeconds
		      Dim Length As Double = LastMouseOver.Length
		      If DayEventClicked then
		        'tmpDate.Hour = 0
		        'tmpDate.Minute = 0
		        'tmpDate.Second = 0
		        tmpDate = tmpDate - new DateInterval(0,0,0,tmpDate.Hour,tmpDate.Minute,tmpDate.Second)
		        LastMouseOver.StartDate = New DateTime(tmpDate)
		        LastMouseOver.SetLength(Length)
		      else
		        'LastMouseOver.StartDate = New DateTime(tmpDate)
		        'LastMouseOver.StartDate.SecondsFrom1970 = Max(tmpDate.SecondsFrom1970 - tmpDate.Hour * 3600 - tmpDate.Minute * 60, tmpDate.SecondsFrom1970 - DragOffset)
		        LastMouseOver.StartDate = New DateTime(Max(tmpDate.SecondsFrom1970 - tmpDate.Hour * 3600 - tmpDate.Minute * 60, tmpDate.SecondsFrom1970 - DragOffset), TimeZone.Current)
		        LastMouseOver.SetLength(Length)
		      End If
		      
		      If lastStart <> LastMouseOver.StartSeconds then
		        DragEvent(LastMouseOver)
		        Redisplay
		      End If
		      
		    End If
		  End if
		  '
		  'While Y > Height-10
		  'AutoScroll(0, 1)
		  'Wend
		  ''If Y > Height-10 then
		  ''AutoScroll(0, 1)
		  ''End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub HandleLoader(Hide As Boolean = False)
		  #if TargetDesktop
		    #Pragma Unused Hide
		  #elseif TargetWeb
		    If not Hide then
		      ExecuteJavaScript("Xojo.get('" + me.ControlID + "_loader').style.display = 'inherit';")
		    Else
		      ExecuteJavaScript("Xojo.get('" + me.ControlID + "_loader').style.display = 'none';")
		    End If
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function handleMouseDown(X As Integer, Y As Integer) As Boolean
		  #if TargetDesktop
		    If me.AllowFocus then
		      me.SetFocus
		    End If
		    
		    DragBack = False
		    DragEvent = 0
		    DragEventPerformed = False
		    
		    If IsContextualClick then
		      Return False
		    End If
		    
		    If ViewType > TypeMonth and X > Width-ScrollBarWidth-1 then
		      MovingScrollBar = True
		      lastX = X
		      lastY = Y
		      #if TargetDesktop
		        Return True
		      #endif
		      
		    Else
		      MovingScrollBar = False
		    End If
		    
		  #Endif
		  
		  
		  
		  'If not DragEvents and not CreateWithDrag then Return False
		  
		  //Type Picker
		  If ViewType = TypePicker then
		    
		    //Nothing
		    #if TargetDesktop
		      Return True
		    #Else
		      Return
		    #endif
		    
		    
		    //Type Month
		  ElseIf ViewType = TypeMonth then
		    
		    LastMouseOver = EventForXY(X, Y)
		    
		    If LastMouseOver is Nil then
		      'If not CreateWithDrag then Return False
		      
		      If MonthsPopup.Visible then
		        Dim r As New Xojo.Rect(MonthsPopup.Left, MonthsPopup.Top, MonthsPopup.Width, MonthsPopup.Height)
		        If r.Contains(New xojo.Point(X, Y)) Then
		          
		          If picCloseMonthPopup <> Nil then
		            #if DebugBuild
		              dim m As MonthPopup
		              m = self.MonthsPopup
		            #endif
		            If X>= MonthsPopup.left+MonthsPopup.Width-picCloseMonthPopup.Width-2 and Y<MonthsPopup.Top+17 then
		              MonthsPopup.visible = False
		              Redisplay()
		            End If
		          End If
		          
		          Return False
		        End If
		      End If
		      
		      If CreateWithDrag then
		        SelStart = DateForXY(X, Y)
		      End If
		      
		      If MonthsPopup.Visible then
		        MonthsPopup.Visible = False
		        Redisplay()
		      End If
		      
		      
		    else
		      
		      
		      
		      
		      #if TargetDesktop
		        If LastMouseOver.Visible = False then
		          Return True
		          
		        End If
		        If not DragEvents then Return True // False
		        'If LastMouseOver.Visible = False then Return False
		        
		        If LastMouseOver.Editable then
		          
		          DragEvent = DragMove
		          MouseCursor = System.Cursors.ArrowAllDirections
		          
		        End If
		        lastX = X
		        lastY = Y
		        Return True
		      #endif
		      
		    End If
		    
		    
		    //Type Week
		  elseif ViewType > TypeMonth then
		    #if TargetWeb
		      
		      LastMouseOver = EventForXY(X, Y)
		      
		      If LastMouseOver is Nil then
		        If not CreateWithDrag then Return
		        
		        DayEventClicked = (Y < ViewHeight)
		        SelStart = DateForXY(X, Y)
		      else
		        
		      end if
		    #Elseif TargetDesktop
		      
		      If Y > me.ViewHeight-3 and Y < me.ViewHeight+2 and not LockDayEventsHeight then
		        me.MouseCursor = System.Cursors.ArrowNorthSouth
		        DragViewHeight = True
		        
		        
		      elseif LastMouseOver is Nil then
		        If not CreateWithDrag then Return False
		        
		        DayEventClicked = (Y < ViewHeight )
		        SelStart = DateForXY(X, Y)
		        
		      else
		        If not DragEvents then Return True //False
		        
		        DayEventClicked = (Y < ViewHeight )
		        
		        If LastMouseOver.Editable then
		          If Y>ViewHeight and Y >LastMouseOver.DrawY+LastMouseOver.DrawH - 6 then
		            DragEvent = DragResize
		            
		          else
		            DragEvent = DragMove
		            DragOffset = DateForXY(X, Y).SecondsFrom1970 - LastMouseOver.StartSeconds
		            MouseCursor = System.Cursors.ArrowAllDirections
		            If not DayEventClicked then
		              LastMouseOver.MouseOver = True
		            End If
		          End If
		        else
		          DragEvent = DragView
		        End If
		        
		        LastMouseOver.FrontMost = True
		        
		      End If
		    #endif
		    
		  End If
		  
		  lastX = X
		  lastY = Y
		  
		  #if TargetWeb
		    lastMouseDown = System.Ticks
		    If SelStart <> Nil then
		      SelEnd = New DateTime(SelStart)
		      Redisplay()
		    End If
		    
		  #Elseif TargetDesktop
		    Redisplay()
		    
		    If DragViewHeight or SelStart <> Nil or DragEvent>0 then
		      Return True
		    End If
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub handleMouseUp(X As Integer, Y As Integer)
		  #pragma Unused X
		  #pragma Unused Y
		  
		  
		  
		  #if TargetDesktop
		    If MouseCursor <> System.Cursors.StandardPointer then
		      MouseCursor = System.Cursors.StandardPointer
		    End If
		  #endif
		  
		  DragViewHeight = False
		  
		  #If TargetDesktop
		    If DragEvent > 0 and DragEventPerformed then
		      RaiseEvent DropEvent(LastMouseOver)
		      DragEvent = 0
		      If LastMouseOver.DayEvent = False then
		        LastMouseOver.MouseOver = True
		      End If
		      LastMouseOver.FrontMost = False
		      LastMouseOver.Buffer = Nil
		      EventsSorted = False
		      EraseBuffers()
		      Redisplay()
		      Return
		    End If
		    
		  #elseif TargetWeb
		    Dim E As CalendarEvent = EventForXY(X, Y, True)
		    Dim Idx As Integer
		    If E <> Nil and E.Visible and E.Editable then
		      E.Buffer = Nil
		      
		      Idx = Events.IndexOf(E)
		      Dim tmpEvent As CalendarEvent
		      tmpEvent = EditEvent(E)
		      If tmpEvent <> Nil then
		        If tmpEvent.RecurrenceParent <> Nil then
		          Dim ParentEvent As CalendarEvent = CalendarEvent(tmpEvent.RecurrenceParent.Value)
		          idx = Events.IndexOf(ParentEvent)
		          
		          If not EditOrDeleteRecurrentEvent(ParentEvent) then
		            Return
		          End If
		          
		          Dim length As Integer = tmpEvent.Length
		          
		          tmpEvent.setDate(ParentEvent.StartDate)
		          tmpEvent.SetLength(length)
		          tmpEvent.RecurrenceParent = Nil
		          
		          If Idx > -1 Then
		            Redim DisplayEvents(-1)
		          End If
		          
		        End If
		        
		        If Idx > -1 Then
		          Events.RemoveAt(Idx)
		          Events.AddAt(Idx, tmpEvent)
		          
		          #if TargetDesktop
		            FullRefresh = True
		            Refresh(False)
		          #elseif TargetWeb
		            Redisplay()
		          #endif
		        End If
		      End If
		      Return
		    End If
		  #endif
		  
		  //Type Picker
		  If ViewType = TypePicker then
		    If X < 15 and Y<36 then
		      'DisplayDate.Day = 1
		      'DisplayDate.Month = DisplayDate.Month -1
		      DisplayDate = New DateTime(DisplayDate)
		      DisplayDate = DisplayDate - New DateInterval(0,0,DisplayDate.Day-1)
		      DisplayDate = DisplayDate - DIMonth
		      mFirstDate = Nil
		      
		      ViewChanged()
		    elseif X > Width-15 and Y<36 then
		      'DisplayDate.Day = 1
		      'DisplayDate.Month = DisplayDate.Month +1
		      DisplayDate = New DateTime(DisplayDate)
		      DisplayDate = DisplayDate - New DateInterval(0,0,DisplayDate.Day-1)
		      DisplayDate = DisplayDate + DIMonth
		      mFirstDate = Nil
		      
		      ViewChanged()
		      
		    Elseif Y < 36 then
		      Return
		      
		      'If PickerView < PickerDecade then
		      'PickerView = PickerView + 1
		      'End If
		      'mYearPicker = New CalendarYearPicker
		      
		    else
		      Dim D As DateTime = DateForXY(X, Y)
		      
		      If PickerView = PickerDay then
		        DisplayDate = New DateTime(D)
		      Elseif PickerView = PickerMonth then
		        'DisplayDate.Month = D.Month
		        Var dd As DateTime = DisplayDate
		        DisplayDate = New DateTime(dd.Year,d.Month,dd.Day,dd.Hour,dd.Minute,dd.Second,dd.Nanosecond,dd.Timezone)
		        
		      End If
		      
		      If PickerView > 0 then
		        PickerView = PickerView-1
		      End If
		      
		      DateSelected(D)
		      
		      
		    End If
		    
		    Redisplay()
		    
		    Return
		    
		  Elseif ViewType = TypeMonth and LastMouseOver <> Nil and LastMouseOver.Visible = False then
		    //User clicked the +# event
		    Dim D As DateTime = DateForXY(X, Y)
		    If RaiseEvent ShowMoreEvents(D) then
		      Return
		    Else
		      MonthsPopup.Visible = True
		      MonthsPopup.SQLDate = D.SQLDate
		      
		      Redisplay()
		    End If
		    
		  End If
		  
		  If DropObject then
		    DropObject = False
		    Return
		  End If
		  
		  If LastMouseOver <> Nil then
		    RaiseEvent EventClicked(lastMouseOver)
		  End If
		  
		  If SelStart is Nil and DragEvent = 0 then
		    Return
		  End If
		  
		  
		  
		  If ViewType = TypeMonth and LastMouseOver is Nil then
		    
		    SelStart = SelStart - New DateInterval(0,0,0,SelStart.Hour,SelStart.Minute,SelStart.Second)
		    'SelStart.Hour = 0
		    'SelStart.Minute = 0
		    'SelStart.Second = 0
		    
		    Freeze = True
		    DisplayDate = SelStart
		    Freeze = False
		    
		    If SelEnd <> Nil then
		      SelEnd = SelEnd - New DateInterval(0,0,0,SelEnd.Hour,SelEnd.Minute,SelEnd.Second)
		      
		      'SelEnd.Hour = 0
		      'SelEnd.Minute = 0
		      'SelEnd.Second = 0
		      
		      
		      #if TargetWeb
		        If System.Ticks-lastMouseDown > 30 or SelEnd <> Nil then
		          NewEvent(SelStart, SelEnd)
		        End If
		      #else
		        NewEvent(SelStart, SelEnd)
		      #endif
		      
		      'EraseBuffers()
		      SelStart = Nil
		      SelEnd = Nil
		      #if TargetDesktop
		        FullRefresh = True
		        Refresh(False)
		      #elseif TargetWeb
		        Redisplay()
		      #endif
		    else
		      SelStart = Nil
		      SelEnd = Nil
		    End If
		    
		    
		    
		  elseif ViewType > TypeMonth and not MovingScrollBar then
		    
		    If LastMouseOver <> Nil then
		      LastMouseOver.FrontMost = False
		      LastMouseOver.Buffer = Nil
		      Redisplay
		    End If
		    
		    #If TargetWeb
		      //Wasn't created in MouseDrag
		      SelEnd = DateForXY(X, Y)
		    #endif
		    
		    If SelEnd <> Nil then
		      
		      #if TargetWeb
		        If SelStart.SecondsFrom1970 = SelEnd.SecondsFrom1970 Then
		          SelEnd.SecondsFrom1970 = SelEnd.SecondsFrom1970 + 3600
		        End If
		      #endif
		      
		      
		      //Preventing Length = 0 events
		      If SelStart.SecondsFrom1970 <> SelEnd.SecondsFrom1970 or DayEventClicked then
		        NewEvent(SelStart, SelEnd)
		      End If
		      
		      EraseBuffers()
		      SelStart = Nil
		      SelEnd = Nil
		      
		      #if TargetDesktop
		        FullRefresh = True
		        Refresh(False)
		      #elseif TargetWeb
		        Redisplay()
		      #endif
		    Else
		      SelStart = Nil
		      SelEnd = Nil
		      
		    End If
		    
		    
		    
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub handlePaint(g As Graphics, areas() As Xojo.Rect)
		  #Pragma Unused areas
		  'Dim mp As new MethodProfiler(CurrentMethodName)
		  
		  //If control not initialized we return
		  If g is Nil then
		    Return
		  End If
		  
		  If Freeze or Width <= 5 or Height <= 5 or Today is Nil then
		    //Drawing Buffer to the display
		    g.DrawPicture(Buffer, 0, 0)
		    Return
		  End If
		  
		  //In DebugBuild we check performance of drawing
		  #if DebugBuild
		    Dim ms As Double = System.Microseconds
		  #endif
		  
		  
		  
		  #if TargetCocoa then
		    FullRefresh = True
		  #endif
		  
		  'If areas.Ubound>-1 then
		  'g =g 
		  'End If
		  
		  
		  //We check if we need to create a new buffer
		  If Buffer is Nil or Width * Height <> lastSize or FullRefresh  or lastToday.SecondsFrom1970 <> Today.SecondsFrom1970  then
		    
		    Dim gg As Graphics
		    
		    
		    #if TargetCocoa
		      gg = g
		    #elseif TargetWin32
		      Buffer = New Picture(Width, Height, 32)
		      
		      If Buffer is Nil then Return
		      gg = Buffer.Graphics
		      
		    #else
		      If TextFont = "" then TextFont = "System"
		      Buffer = New Picture(Width, Height)
		      
		      If Buffer is Nil then Return
		      gg = Buffer.Graphics
		    #endif
		    
		    If Width*Height <> lastSize then
		      EraseBuffers
		      lastSize = Width * Height
		    End If
		    
		    Call HiDPI //Initialize the HiDPI property for the rest of the drawing.
		    
		    lastToday = New DateTime(Today)
		    
		    
		    
		    If ViewType = TypePicker then
		      
		      If mLastDate is Nil then
		        Call LastDate
		      End If
		      
		      DrawPicker(gg)
		      
		      //Displaying entire year
		    ElseIf ViewType = TypeYear then
		      
		      
		      DrawBackgroundYear(gg)
		      
		      //Displaying entire Month
		    ElseIf ViewType = TypeMonth then
		      
		      If mLastDate is Nil then
		        Call LastDate
		      End If
		      
		      HeaderHeight = 48
		      Dim DayWidth As Single = g.Width / 7
		      Dim DayHeight As Single = (g.Height - HeaderHeight) / WeeksPerMonth
		      
		      
		      //Drawing Background
		      DrawBackgroundMonth(gg, WeeksPerMonth, DayWidth, DayHeight, True)
		      
		      //Drawing Events
		      DrawEventsMonth(gg, WeeksPerMonth, DayWidth, DayHeight)
		      
		      
		      
		    elseif ViewType >= TypeWeek then
		      
		      HeaderHeight = 23
		      Dim DayWidth As Single = (g.Width - TimeWidth) / ViewDays
		      HourHeight = max(minHourHeight, Ceiling((g.Height-(HeaderHeight + MyStyle.WEventHeight))/VisibleHours))
		      
		      //Drawing Background
		      DrawBackgroundWeek(gg, DayWidth)
		      
		      //Drawing Events
		      DrawEventsWeek(gg, DayWidth)
		      
		      //Draw Time
		      DrawTime(gg, DayWidth)
		      
		      //Drawing Scrollbar
		      If ShowScrollBar then
		        DrawScrollBar(gg)
		      End If
		      
		    End If
		    
		    'MethodProfiler.LogMsg("FullRefresh=False")
		    FullRefresh = False
		  End If
		  
		  #if not TargetMacOS
		    //Drawing Buffer to the display
		    If not Animate or AnimationInProgress=0 then
		      'MethodProfiler.LogMsg("Drawing Buffer")
		      g.DrawPicture(Buffer, 0, 0)
		      
		    else
		      
		      Dim frameRate As Integer = 60
		      Dim AnimationTime As Integer = 800
		      Dim Times() As Double
		      Dim Pos() As Integer
		      Dim i, MaxFrame As Integer
		      MaxFrame = frameRate / (1000 / AnimationTime)
		      Redim Times(MaxFrame)
		      Redim Pos(MaxFrame)
		      Dim currentTime As Double
		      Dim TimePerFrame As Double = 1000 / frameRate
		      
		      For i = 0 to MaxFrame
		        Times(i) = TimePerFrame * (i+1)
		        If AnimationInProgress >0 then
		          Pos(i) = Width - Width * i/MaxFrame
		        else
		          Pos(i) = Width*i/MaxFrame
		        End If
		      Next
		      
		      Dim startTime As Double = System.Microseconds/1000
		      
		      For i = 0 to MaxFrame
		        currentTime = System.Microseconds / 1000
		        
		        If i<MaxFrame and i>0 and currentTime - startTime > Times(i) then
		          Continue for i
		        End If
		        While i>0 and currentTime-startTime <  Times(i-1)
		          App.DoEvents (max(1, Times(i-1) - (currentTime-startTime)-1))
		          currentTime = System.Microseconds / 1000
		        Wend
		        
		        If AnimationInProgress>0 then
		          g.DrawPicture(oldBuffer, 0, 0, Pos(i), Height, Width-Pos(i))
		          g.DrawPicture(Buffer, Pos(i), 0)
		        else
		          
		          g.DrawPicture(oldBuffer, Pos(i), 0)
		          g.DrawPicture(Buffer, 0, 0, Pos(i), Height, Width-Pos(i))
		        End If
		      Next
		      
		      AnimationInProgress = 0
		      g.DrawPicture(Buffer, 0, 0)
		      oldBuffer = Nil
		    End If
		  #endif
		  
		  #if not DebugBuild
		    If not Registered then
		      g.DrawingColor = &cFF0000
		      g.Bold = True
		      g.FontSize = 16
		      g.DrawText("Demo Version", (g.Width-g.TextWidth("Demo Version"))\2, g.Height\2)
		    End If
		  #elseif TargetWeb
		    g.DrawPicture(Buffer, 0, 0)
		  #endif
		  
		  #if TargetWeb
		    g.DrawingColor = &cFF0000
		    g.FontSize = 12
		    g.FontName = "System"
		    g.Bold = True
		    g.DrawText("Beta", g.Width-40, g.Height-10)
		  #endif
		  
		  
		  //In DebugBuild we check performance of drawing
		  #if DebugBuild
		    ms = (System.Microseconds-ms)/1000
		    'g.DrawingColor = &c0
		    'g.FontSize = 12
		    'g.Bold = False
		    'g.DrawText(str(ms), 0, 10)
		    'g.DrawingColor = &cFF0000
		    'g.DrawText(str(ScrollPosition), 10, 20)
		    'g.DrawText(DrawInfo, 0, 25)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function HiDPI() As Integer
		  #If TargetCocoa Then
		    Try
		      Soft Declare Function BackingScaleFactor Lib "AppKit" Selector "backingScaleFactor" (target As Ptr) As Double
		      Return BackingScaleFactor(Self.Window.Handle)
		    Catch e As ObjCException
		      Return 1
		    End Try
		    
		  #Elseif TargetWin32
		    Declare Function GetDC Lib "user32" (hWnd As Ptr) As Ptr
		    Declare Function GetDeviceCaps Lib "gdi32" _
		    (hdc As Ptr, nIndex As Integer) As Integer
		    Declare Sub ReleaseDC Lib "user32" (hWnd As Ptr, hdc As Ptr)
		    
		    Const LOGPIXELSX = 88
		    Const LOGPIXELSY = 90
		    
		    Dim hdc As Ptr = GetDC(Nil)
		    Dim dpiX As Integer = GetDeviceCaps(hdc, LOGPIXELSX)
		    Dim dpiY As Integer = GetDeviceCaps(hdc, LOGPIXELSY)
		    ReleaseDC(Nil, hdc)
		    
		    Dim scaleFactorX As Double = dpiX / 96
		    Dim scaleFactorY As Double = dpiY / 96
		    Return max(scaleFactorX, scaleFactorY)
		    
		  #Else
		    Return 1
		  #Endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ImportFromDB(RS As RowSet, ID As String = "ID", StartDate As String = "Start", EndDate As String = "End", Title As String = "Title", EventColor As String = "Color", Location As String = "Location", Description As String = "Description", Recurrence As String = "Recurrence", Editable As Boolean = True, AllDay As Boolean = False) As Boolean
		  //Imports CalendarEvents from a Database.
		  //Returns True if import is successful.
		  //
		  //If you set the AllDay parameter to True, all events will be a Day event.
		  
		  If RS is Nil then Return False
		  If RS.RowCount = 0 then Return False
		  
		  Dim cEvent As CalendarEvent
		  
		  While not RS.AfterLastRow
		    cEvent = New CalendarEvent
		    
		    'cEvent.StartDate = New DateTime
		    'cEvent.StartDate.SQLDateTime = RS.Column(StartDate).StringValue
		    cEvent.StartDate = DateTime.FromString(RS.Column(StartDate).StringValue)
		    
		    cEvent.EndDate = New DateTime(cEvent.StartDate)
		    
		    If EndDate <> "" then
		      If RS.Column(StartDate).StringValue = RS.Column(EndDate).StringValue then
		        
		      elseif RS.Column(EndDate).StringValue <> "" then
		        'cEvent.EndDate.SQLDateTime = RS.Column(EndDate).StringValue
		        cEvent.EndDate = DateTime.FromString(RS.Column(EndDate).StringValue)
		      End If
		    End If
		    
		    If AllDay then
		      'cEvent.StartDate.Hour = 0
		      'cEvent.StartDate.Minute = 0
		      'cEvent.StartDate.Second = 0
		      cEvent.StartDate = cEvent.StartDate - New DateInterval(cEvent.StartDate.Year,cEvent.StartDate.Month,cEvent.StartDate.day,0,0,0)
		      cEvent.EndDate = New DateTime(cEvent.StartDate)
		    End If
		    
		    cEvent.ID = RS.Column(ID).StringValue
		    cEvent.Title = RS.Column(Title).StringValue
		    If EventColor <> "" then
		      cEvent.EventColor = String2Color(RS.Column(EventColor).StringValue)
		    End If
		    If Location <> "" then
		      cEvent.Location = RS.Column(Location).StringValue
		    End If
		    If Description <> "" then
		      cEvent.Description = RS.Column(Description).StringValue
		    End If
		    If Recurrence <> "" then
		      If RS.Column(Recurrence).StringValue <> "" then
		        cEvent.Recurrence = New CalendarRecurrence(RS.Column(Recurrence).StringValue)
		      End If
		    End If
		    
		    cEvent.Editable = Editable
		    
		    
		    Events.Add cEvent
		    
		    RS.MoveToNextRow()
		  Wend
		  
		  SelStart = Nil
		  SelEnd = Nil
		  
		  mFirstDate = Nil
		  mLastDate = Nil
		  
		  Redim DisplayEvents(-1)
		  
		  Redisplay()
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ImportFromJSON(JS As JSONItem) As Boolean
		  //Imports a CalendarEvent from a JSONItem
		  //Returns True if import is successful.
		  //
		  //If you set the AllDay parameter to True, all events will be a Day event.
		  
		  #if RBVersion > 2013
		    
		    Dim cEvent As CalendarEvent
		    
		    
		    cEvent = New CalendarEvent
		    If JS.HasKey("Title") then
		      cEvent.Title = JS.Value("Title").StringValue
		    End If
		    If JS.HasKey("StartDate") then
		      cEvent.StartDate = JS.Value("StartDate").DateTimeValue
		    End If
		    If JS.HasKey("EndDate") then
		      cEvent.EndDate = JS.Value("EndDate").DateTimeValue
		    End If
		    If JS.HasKey("Color") then
		      cEvent.EventColor = JS.Value("Color").ColorValue
		    End If
		    If JS.HasKey("Location") then
		      cEvent.Location = JS.Value("Location").StringValue
		    End If
		    If JS.HasKey("Description") then
		      cEvent.Description = JS.Value("Description").StringValue
		    End If
		    If JS.HasKey("ID") then
		      cEvent.ID = JS.Value("ID").StringValue
		    End If
		    If JS.HasKey("Editable") then
		      cEvent.Editable = JS.Value("Editable").BooleanValue
		    End If
		    If JS.HasKey("Tag") then
		      cEvent.Tag = JS.Value("Tag")
		    End If
		    If JS.HasKey("Recurrence") then
		      Dim Rec As New CalendarRecurrence(JS.Value("Recurrence").StringValue)
		      cEvent.Recurrence = Rec
		    End If
		    
		    #if False
		      If JS.HasKey("title") then
		        Title = js.Value("title")
		      End If
		      
		      Dim jsChild, jsChildren, jsChildren2, jsData As JSONItem
		      Dim i, j As Integer
		      
		      Dim cs As ChartSerie
		      
		      jsChildren = js.Lookup("children", Nil)
		      If jsChildren is Nil then
		        System.DebugLog("The json item doesn't contain any children node")
		        Return
		      End If
		      
		      InitSeries(jsChildren.Count-1)
		      
		      For i = 0 to jsChildren.Count-1
		        jsChild = jsChildren.Child(i)
		        
		        cs = Series(i)
		        
		        //Title of the ChartSerie
		        If jsChild.HasName("title") then
		          cs.Title = jsChild.Value("title")
		        End If
		        
		        
		        //Color
		        If jsChild.HasName("color") then
		          cs.FillColor = &cFF0000
		        End If
		        
		        If jsChild.HasName("children") then
		          jsChildren2 = jsChild.Child("children")
		          For j = 0 to jsChildren2.Count-1
		            
		            jsData = jsChildren2.Child(j)
		            
		            If jsData.HasName("label") then
		              cs.Labels.Append jsData.Value("label")
		            Elseif jsData.HasName("name") then
		              cs.Labels.Append jsData.Value("name")
		            End If
		            
		            cs.Values.Append jsData.Lookup("value", Nil)
		          Next
		        End If
		        
		        
		      Next
		    #endif
		    
		  #else
		    #if DebugBuild
		      MsgBox("LoadFromJSON function isn't available in RealStudio")
		    #endif
		    
		    
		  #endif
		  
		  
		  SelStart = Nil
		  SelEnd = Nil
		  
		  mFirstDate = Nil
		  mLastDate = Nil
		  
		  Redim DisplayEvents(-1)
		  
		  Redisplay()
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ImportICS(f As FolderItem, DefaultColor As Color = &c4986E7, Editable As Boolean = False)
		  //Imports CalendarEvents from a ICS/VCS file (iCal format)
		  
		  If f <> Nil and f.Exists then
		    ImportICS(TextInputStream.Open(f).ReadAll, DefaultColor, Editable)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ImportICS(txt As String, DefaultColor As Color = &c4986E7, Editable As Boolean = False)
		  //Imports CalendarEvents from a ICS/VCS formated string (iCal format)
		  
		  'Dim mp As new MethodProfiler(CurrentMethodName)
		  
		  #if DebugBuild
		    Dim ms As Double = System.Microseconds
		  #endif
		  
		  Dim Lines() As String = txt.ReplaceLineEndings(EndOfLine).Split(EndOfLine)
		  
		  txt = ""
		  
		  Dim i, u As Integer
		  
		  Dim DocumentOK As Boolean
		  
		  u = Lines.LastIndex
		  
		  If u>1000 then
		    Freeze = True
		  End If
		  
		  Dim Summary, Description, Location, UID As String
		  Dim DateStart As DateTime
		  Dim DateEnd As DateTime
		  Dim Recurrence As CalendarRecurrence
		  Dim Item, Value As String
		  Dim HasColor As Boolean
		  Dim MyColor As Color
		  Dim Tag As Variant
		  
		  try
		    For i = 0 to u
		      If not DocumentOK then
		        If Lines(i) = "BEGIN:VCALENDAR" then
		          DocumentOK = True
		        End If
		        
		      else
		        Lines(i) = Lines(i).Trim
		        
		        Item = Lines(i).NthField(":", 1)
		        Value = Lines(i).Middle(Item.Length + 2)
		        Item = Item.NthField(";", 1)
		        
		        
		        Select Case Item
		          
		        Case "BEGIN"
		          If Lines(i) = "BEGIN:VEVENT" then
		            
		            Summary = ""
		            Description = ""
		            Location = ""
		            UID = ""
		            DateStart = Nil
		            DateEnd = Nil
		            
		            
		          End If
		          
		        Case "DTSTART"
		          
		          DateStart = New DateTime(VDate2SQLDate(Value))
		          
		        Case "SUMMARY"
		          Summary = Value
		          
		        Case "DESCRIPTION"
		          Description = Value
		          
		        Case "LOCATION"
		          Location = Value
		          
		        Case "UID"
		          UID = Value
		          
		        Case "DTEND"
		          
		          DateEnd = New DateTime(VDate2SQLDate(Value))
		          
		        Case "RRULE"
		          
		          Recurrence = New CalendarRecurrence(Value)
		          
		        Case "X-RSCV-COLOR"
		          HasColor = True
		          MyColor = Color.RGB(val("&h" + Value.Middle(2, 2)), val("&h" + Value.Middle(4, 2)), val("&h" + Value.Middle(6, 2)))
		          
		        Case "X-RSCV-TAG"
		          Tag = Value
		          
		        Case "END"
		          If Lines(i) = "END:VEVENT" then
		            If DateStart <> Nil then
		              
		              'If UID <> "" then UID=str(System.Microseconds)
		              
		              If HasColor then
		                me.AddEvent New CalendarEvent(Summary, DateStart, DateEnd, MyColor, Location, _
		                Description, UID, Editable, Tag, Recurrence)
		              else
		                me.AddEvent New CalendarEvent(Summary, DateStart, DateEnd, DefaultColor, Location, _ 
		                Description, UID, Editable, Tag, Recurrence)
		              End If
		            End If
		            
		            HasColor = False
		            
		          End If
		          Tag = Nil
		          Recurrence = Nil
		          
		        End Select
		      End If
		      
		      
		      
		    Next
		    
		    
		  Catch
		    
		  End Try
		  
		  #if DebugBuild
		    ms = (System.Microseconds-ms)/1000
		    'DrawInfo = str(ms)
		  #endif
		  
		  'Refresh(False)
		  Freeze = False
		  Redisplay
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function InvertColor(c As Color) As Color
		  
		  Return Color.RGB(255-c.Red, 255-c.Green, 255-c.Blue)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ISOWeekNumber(dt As DateTime) As Integer
		  // ISO 8601 week number
		  // https://en.wikipedia.org/wiki/ISO_week_date
		  
		  var dow,woy as UInt8
		  
		  dow=dt.DayOfWeek-1
		  if dow=0 then dow=7
		  woy=Floor((10+dt.DayOfYear-dow)/7)
		  
		  if woy=0 then
		    var dp as new DateTime (dt.Year-1,12,31)
		    dow=dp.DayOfWeek-1
		    if dow=0 then dow=7
		    woy=Floor((10+dp.DayOfYear-dow)/7)
		  elseif woy=53 then
		    var dp as new DateTime (dt.Year+1,1,1)
		    dow=dp.DayOfWeek
		    if dow<6 and dow>1 then woy=1
		  end if
		  
		  Return woy
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function mixColor(frontC As Color, BackC As Color, Alpha As Integer) As Color
		  Dim c As Color
		  Dim a As Single = (255-Alpha) / 255
		  Dim b As Single = Alpha / 255
		  
		  c = Color.RGB( frontC.red * a + BackC.Red * b,  frontC.Green * a + BackC.Green * b,  frontC.Blue * a + BackC.Blue * b)
		  
		  Return C
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ParseDate(D As DateTime, Format As String, Default As String = "") As String
		  If D is Nil then Return ""
		  
		  If Format = "" then
		    If Default = "" then Return D.ToString(DateTime.FormatStyles.Long, DateTime.FormatStyles.None)
		    
		    Format = Default
		  End If
		  
		  Dim lText As String = Format
		  
		  //Default formats
		  If lText.IndexOf("Long Date")>0 then
		    lText = lText.Replace("Long Date", D.ToString(DateTime.FormatStyles.Long, DateTime.FormatStyles.None))
		  elseif lText.IndexOf("longdate")>0 then
		    lText = lText.Replace("Longdate", D.ToString(DateTime.FormatStyles.Long, DateTime.FormatStyles.None))
		  elseif lText.IndexOf("Short Date")>0 then
		    lText = lText.Replace("Short Date", D.ToString(DateTime.FormatStyles.Short, DateTime.FormatStyles.None))
		  elseif lText.IndexOf("ShortDate")>0 then
		    lText = lText.Replace("Shortdate", D.ToString(DateTime.FormatStyles.Short, DateTime.FormatStyles.None))
		  elseif lText.IndexOf("Abbreviated Date")>0 then
		    lText = lText.Replace("Abbreviated Date", D.ToString(DateTime.FormatStyles.Medium, DateTime.FormatStyles.None)) 'AbbreviatedDate)
		  elseif lText.IndexOf("AbbreviatedDate")>0 then
		    lText = lText.Replace("AbbreviatedDate", D.ToString(DateTime.FormatStyles.Medium, DateTime.FormatStyles.None)) 'AbbreviatedDate)
		  elseif lText.IndexOf("SQLDateTime")>0 then
		    lText = lText.Replace("SQLDateTime", D.SQLDateTime)
		  elseif lText.IndexOf("SQLDate")>0 then
		    lText = lText.Replace("SQLDate", D.SQLDate)
		  End If
		  
		  If lText <> Format then
		    Return lText
		  End If
		  
		  Dim Chars() As String = Format.Split("")
		  
		  Dim i As Integer
		  Dim u As Integer = Chars.LastIndex
		  For i = u DownTo 1
		    If Chars(i).left(1) = Chars(i-1) or chars(i-1) = "\" then
		      Chars(i-1) = Chars(i-1) + Chars(i)
		      Chars.RemoveAt(i)
		    End If
		  Next
		  
		  u = Chars.LastIndex
		  For i = 0 to u
		    lText = Chars(i)
		    
		    If lText.left(1) = "\" then
		      Chars(i) = lText.Middle(2)
		      Continue for i
		    End If
		    
		    //Day
		    If lText.IndexOfBytes("dddd")>0 then
		      lText = lText.ReplaceBytes("dddd", DayNames(D.DayOfWeek))
		    elseif lText.IndexOfBytes("l")>0 then
		      lText = lText.ReplaceBytes("l", DayNames(D.DayOfWeek))
		      
		      //Thanks to Dr. Michael Oeser for this suggestion
		    ElseIf lText.IndexOfBytes("dd")>0 then
		      lText = lText.ReplaceBytes("dd", DayNames(D.DayOfWeek).Left(2))
		    ElseIf lText.IndexOfBytes("ddd")>0 then
		      lText = lText.ReplaceBytes("ddd", DayNames(D.DayOfWeek).Left(3))
		    ElseIf lText.IndexOfBytes("d")>0 then
		      lText = lText.ReplaceBytes("d", Format(D.Day, "00"))
		    elseif lText.IndexOfBytes("j")>0 then
		      lText = lText.ReplaceBytes("j", str(D.Day))
		    ElseIf lText.IndexOfBytes("mmmm")>0 then
		      lText = lText.ReplaceBytes("mmmm", MonthNames(D.Month))
		    elseif lText.IndexOfBytes("mm")>0 then
		      lText = lText.ReplaceBytes("mm", Format(D.Month, "00"))
		    elseif lText.IndexOfBytes("m")>0 then
		      lText = lText.ReplaceBytes("m", Format(D.Month, "00"))
		    elseif lText.IndexOfBytes("n")>0 then
		      lText = lText.ReplaceBytes("n", str(D.Month))
		    elseif lText.IndexOfBytes("N")>0 then
		      lText = lText.ReplaceBytes("N", str((D.DayOfWeek+7-1) mod 7))
		    elseif lText.IndexOfBytes("M")>0 then
		      lText = lText.ReplaceBytes("M", MonthNames(D.Month).Left(3))
		    elseif lText.IndexOfBytes("F")>0 then
		      lText = lText.ReplaceBytes("F", MonthNames(D.Month))
		    elseif lText.IndexOfBytes("w")>0 then
		      lText = lText.ReplaceBytes("w", str(D.DayOfWeek))
		    elseif lText.IndexOfBytes("W")>0 then
		      lText = lText.ReplaceBytes("W", str(D.WeekOfYear))
		    elseif lText.IndexOfBytes("z")>0 then
		      lText = lText.ReplaceBytes("z", str(D.DayOfYear))
		    elseif lText.IndexOfBytes("t")>0 then
		      Dim DD As DateTime = New DateTime(D)
		      'DD.day = 1
		      'DD.Month = DD.Month+1
		      'DD.Day = DD.Day-1
		      DD = DD - New DateInterval(0,0,DD.Day-1)
		      DD = DD + DIMonth
		      DD = DD - DIDay
		      lText = lText.ReplaceBytes("t", str(DD.Day))
		    elseif lText.IndexOfBytes("yyyy")>0 then
		      lText = lText.ReplaceBytes("yyyy", str(D.Year))
		    elseif lText.IndexOfBytes("yy")>0 then
		      lText = lText.ReplaceBytes("yy", D.Year.ToString.Middle(3))
		    elseif lText.IndexOfBytes("Y")>0 then
		      lText = lText.ReplaceBytes("Y", str(D.Year))
		    elseif lText.IndexOfBytes("y")>0 then
		      lText = lText.ReplaceBytes("y", str(D.Year))
		    End If
		    
		    Chars(i) = lText
		  Next
		  
		  Return string.FromArray(Chars,"")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ParseTime(D As DateTime, Format As String, Default As String = "") As String
		  If D is Nil then Return ""
		  
		  If Format = "" then
		    If Default = "" then Return D.ToString(DateTime.FormatStyles.None, DateTime.FormatStyles.Short)
		    
		    Format = Default
		  End If
		  
		  Dim lText As String = Format
		  Dim AMPM As Boolean
		  Dim Hour As Integer = D.Hour
		  
		  If lText.IndexOf("a")>0 then
		    AMPM = True
		  elseif ForceAM_PM then
		    AMPM = True
		  End If
		  
		  If AMPM then
		    If Hour>12 then
		      Hour = Hour - 12
		    End If
		  End If
		  
		  //Hours
		  If lText.IndexOf("hh")>0 Then
		    lText = lText.Replace("hh", Format(Hour, "0#"))
		  elseif lText.IndexOf("h")>0 then
		    lText = lText.Replace("h", str(Hour))
		  End If
		  
		  //Minutes
		  If lText.IndexOf("mm")>0 then
		    lText = lText.Replace("mm", Format(D.Minute, "0#"))
		  elseif lText.IndexOf("m")>0 then
		    lText = lText.Replace("m", str(D.Minute))
		  End If
		  
		  //Seconds
		  If lText.IndexOf("ss")>0 then
		    lText = lText.Replace("ss", Format(D.Second, "0#"))
		  elseif lText.IndexOf("s")>0 then
		    lText = lText.Replace("s", str(D.Second))
		  End If
		  
		  //AM_PM
		  If lText.IndexOfBytes("a")>0 then
		    If D.Hour < 12 then
		      lText = lText.Replace("a", "am")
		    elseif D.Hour>=12 then
		      lText = lText.Replace("a", "pm")
		    End If
		  elseif lText.IndexOfBytes("A")>0 then
		    If D.Hour < 12 then
		      lText = lText.Replace("a", "AM")
		    elseif D.Hour>=12 then
		      lText = lText.Replace("a", "PM")
		    End If
		  elseif AMPM then
		    If D.Hour < 12 then
		      lText = lText + "AM"
		    elseif D.Hour>=12 then
		      lText = lText + "PM"
		    End If
		  End If
		  
		  Return lText
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Print(g As Graphics, PrintToday As Boolean = False)
		  FullRefresh = True
		  Dim Unfreeze As Boolean
		  If not Freeze then
		    Unfreeze = True
		    Freeze = True
		  End If
		  EraseBuffers
		  
		  'Dim lastGDIPlus As Boolean = App.UseGDIPlus
		  'App.UseGDIPlus = true
		  
		  If ViewType = TypePicker then
		    
		    If mLastDate is Nil then
		      Call LastDate
		    End If
		    
		    DrawPicker(g)
		    
		    //Displaying entire year
		  ElseIf ViewType = TypeYear then
		    
		    
		    DrawBackgroundYear(g, True, PrintToday)
		    
		    //Displaying entire Month
		  ElseIf ViewType = TypeMonth then
		    
		    If mLastDate is Nil then
		      Call LastDate
		    End If
		    
		    HeaderHeight = 48
		    Dim DayWidth As Single = g.Width / 7
		    Dim DayHeight As Single = (g.Height - HeaderHeight) / WeeksPerMonth
		    
		    
		    //Drawing Background
		    DrawBackgroundMonth(g, WeeksPerMonth, DayWidth, DayHeight, PrintToday)
		    'Next
		    
		    'ms = (System.Microseconds - ms)/1000
		    'MsgBox(str(ms) + " ms")
		    
		    '//Drawing Background
		    'DrawBackgroundMonth(g, WeeksPerMonth, DayWidth, DayHeight)
		    
		    //Drawing Events
		    DrawEventsMonth(g, WeeksPerMonth, DayWidth, DayHeight)
		    
		    
		    
		  elseif ViewType >= TypeWeek then
		    
		    HeaderHeight = 23
		    Dim DayWidth As Single = (g.Width - TimeWidth) / ViewDays
		    HourHeight = max(minHourHeight, Ceiling((g.Height-(HeaderHeight + MyStyle.WEventHeight))/24))
		    
		    //Drawing Background
		    DrawBackgroundWeek(g, DayWidth, PrintToday)
		    
		    //Drawing Events
		    DrawEventsWeek(g, DayWidth)
		    
		    //Draw Time
		    'DrawTime(g, DayWidth)
		    
		    //Drawing Scrollbar
		    'If ShowScrollBar then
		    'DrawScrollBar(g)
		    'End If
		    
		  End If
		  
		  'app.UseGDIPlus = lastGDIPlus
		  
		  FullRefresh = True
		  If unfreeze then
		    Freeze = False
		  End If
		  EraseBuffers
		  
		  
		  
		  
		  #if not DebugBuild
		    If not Registered then
		      g.DrawingColor = &cFF0000
		      g.Bold = True
		      g.FontSize = 16
		      g.DrawText("Demo Version", (g.Width-g.TextWidth("Demo Version"))\2, g.Height\2)
		    End If
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PrintAdvanced(g As Graphics, PrintToday As Boolean = False)
		  //Prints the current view on the passed graphics property.
		  //
		  //Use this function to handle the Print setup window and the printing area.
		  //
		  //If PrintToday is True, the current day will be highlighted.
		  
		  If g <> Nil then
		    
		    Print(g, PrintToday)
		    
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PrintSimple(PrintToday As Boolean = False)
		  //Prints the current display on the entire sheet of paper (within the print range)
		  //
		  //If PrintToday is True, the current day will be highlighted
		  
		  #if TargetDesktop
		    Dim g as Graphics
		    
		    Dim p as PrinterSetup
		    
		    p=New PrinterSetup
		    
		    If p.ShowPageSetupDialog(self.Window) then
		      
		      //The greater the value, the smaller the text will be when printed.
		      p.MaximumHorizontalResolution=120
		      p.MaximumVerticalResolution=120
		      
		      g = p.ShowPrinterDialog(self.Window)
		      
		      If g <> Nil then
		        
		        Print(g, PrintToday)
		        
		      End if
		      
		      
		    End if
		    
		  #else
		    #Pragma Unused PrintToday
		    
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Redisplay(FilterEvents As Boolean = False)
		  //Erases the buffer and completely refreshes the CalendarView in 10 ms.
		  //The 10 ms delay prevents multiple refreshes when only one would be necessary.
		  
		  'Dim mp As new MethodProfiler(CurrentMethodName)
		  
		  FullRefresh = True
		  If Freeze then
		    Return
		  End If
		  
		  If me.ViewType = TypeYear or FilterEvents then
		    Redim DisplayEvents(-1)
		  End If
		  
		  #if TargetDesktop
		    'Invalidate()
		    '#else
		    If RefreshTimer <> Nil then
		      RefreshTimer.Period = 10
		    End If
		  #elseif TargetWeb
		    If not ControlAvailableInBrowser then Return
		    
		    Dim js() As String
		    
		    'LoaderShow()
		    
		    Dim container As String = me.ControlID + "_container"
		    
		    If ViewType = TypeYear then
		      If ControlAvailableInBrowser then
		        ExecuteJavaScript("Xojo.get('" + container + "').innerHTML = '" + _
		        ReplaceLineEndings(DrawHTMLYear, "").ReplaceAll("'", "\'") +  "<div id=""" + me.controlID + "_img_container""></div>'")
		        ExecuteJavaScript("Xojo.get('" + container + "').style.overflowX = 'auto'; " + _
		        "Xojo.get('" + container + "').style.overflowY = 'auto'; ")
		        
		        
		      End If
		    Elseif ViewType = TypePicker then
		      
		      If ControlAvailableInBrowser then
		        ExecuteJavaScript("Xojo.get('" + container + "').innerHTML = '" + _
		        ReplaceLineEndings(DrawHTMLPicker, "").ReplaceAll("'", "\'") + "<div id=""" + me.controlID + "_img_container""></div>'")
		        ExecuteJavaScript("Xojo.get('" + container + "').style.overflowX = 'hidden'; " + _
		        "Xojo.get('" + container + "').style.overflowY = 'hidden'; ")
		      End If
		    else
		      
		      
		      'ExecuteJavaScript("Xojo.get('" + me.ControlID + "_loader').style.display = 'block';")
		      
		      myPicture = New WebPicture(me.ExportAsPicture)
		      myPicture.Filename = me.ControlID + ".png"
		      'myPicture.MIMEType = "image/png"
		      'myPicture.Data = me.ExportAsPicture.GetData(Picture.FormatPNG)
		      
		      #if DebugBuild
		        #Pragma BreakOnExceptions False
		      #EndIf
		      try
		        If myPicture.Session is nil then
		          myPicture.Session = App.SessionForControlID(self.ControlID)
		          if myPicture.Session is nil then Return
		        End If
		      Catch
		        Return
		      end try
		      
		      
		      If myPicture.URL <> "" then
		        Dim Data As String = "<img src=""" + myPicture.URL + """>"
		        
		        Dim onClick, onScroll As String
		        js.Append "var relObj = Xojo.get(\'" + self.ControlID + "_img_container\');"
		        js.Append "var coordinates = Xojo.input.getCoordinates(relObj, event);"
		        js.Append "Xojo.triggerServerEvent(\'" + me.ControlID + "\',\'MouseDown_\',[coordinates[0].x, coordinates[0].y]); "
		        
		        onClick = Join(Js, " ")
		        
		        Redim js(-1)
		        js.Append "var relObj = Xojo.get(\'" + self.ControlID + "_img_container\');"
		        js.Append "Xojo.triggerServerEvent(\'" + me.ControlID + "\',\'Scroll_\',[relObj.scrollTop]);"
		        
		        onScroll = Join(Js, " ")
		        
		        Dim html As String
		        
		        
		        If ViewType = TypeMonth then
		          html = ReplaceLineEndings(DrawHTMLMonth, "").ReplaceAll("'", "\'")
		        Elseif ViewType >= TypeWeek then
		          html = ReplaceLineEndings(DrawHTMLWeek, "").ReplaceAll("'", "\'")
		        End If
		        
		        
		        'If html <> "" then
		        //onclick=""Xojo.triggerServerEvent('" + Self.ControlID + "','Click',['%value%']); return false;""
		        ExecuteJavascript("var myElem = Xojo.get('" + me.ControlID + "_img2');" + _
		        "if (myElem == null) {" + _
		        "Xojo.get('" + container + "').innerHTML = '" + html + "<div id=""" + me.controlId + _
		        "_img_container"" style=""overflow-x: hidden; overflow-y: hidden"" onmousedown=""" + onClick + """ onmouseup=""" + _
		        onClick.Replace("MouseDown", "MouseUp") + """ onscroll=""" + onScroll + """><img id=""" + me.ControlID + _
		        "_img"" style=""-moz-user-select:none;-webkit-user-select:none;"" src=""a" + myPicture.URL + """/></div>';" + _
		        "}else{" + _
		        "Xojo.get('" + me.ControlID + "_header').outerHTML = '" + html + "';" + _
		        "myElem.src = 'a" + myPicture.URL + "';" + _
		        "};")
		        
		        //Overflows
		        ExecuteJavaScript("Xojo.get('" + container +"').style.overflowX = 'hidden'; Xojo.get('" + container +"').style.overflowY = 'hidden'; ")
		        
		        If ViewType >= TypeWeek then
		          ExecuteJavaScript("Xojo.get('" + me.ControlID + "_img_container').style.overflowY = 'auto'; ")
		        Else
		          ExecuteJavaScript("Xojo.get('" + me.ControlID + "_img_container').style.overflowY = 'hidden'; ")
		        End If
		        
		        ExecuteJavaScript("Xojo.get('" + me.ControlID + "_img_container').style.height = '" + str(me.Height-HeaderHeightHTML) + "px';")
		        
		        //End of Overflows
		        
		        
		        'Else
		        '
		        'ExecuteJavascript("var myElem = Xojo.get('" + me.ControlID + "_img');" + _
		        '"if (myElem == null) {" + _
		        '"Xojo.get('" + container + "').innerHTML = '" + html + "<img id=""" + me.ControlID + "_img"" draggable=""false"" style=""-moz-user-select:none;-webkit-user-select:none;"" src=""" + myPicture.URL + """>';" + _
		        '"}else{" + _
		        '"myElem.src = '" + myPicture.URL + "';" + _
		        '"};")
		        '
		        'End If
		        
		        ExecuteJavaScript("Xojo.get('" + me.controlID + "_img').ondragstart = function() { return false; };")
		        'ExecuteJavaScript("Xojo.get('" + me.controlID + "_img').style.height = '" + str(Height-HeaderHeightHTML) + "px';")
		        
		        
		        
		      End If
		      
		    End If
		    
		    'LoaderHide()
		    
		    
		  #endif
		  '#endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Register(Name As String, SerialKey As String) As Boolean
		  //In order to register this control in your Application, you need to call this method only once.
		  //If the CalendarView is registered, the return Value is True. If the Serial Key does not match the Name, the return Value will be False.
		  
		  
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function Registered() As Boolean
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveEvent(cEvent As CalendarEvent, RemoveFromDB As Boolean = True)
		  //Removes the passed CalendarEvent from the CalendarView
		  //If RemoveFromDB is True, next time ExportToDB is called, all removed events will also be removed from the Database
		  
		  
		  
		  If RemoveFromDB And cEvent.ID.Trim <> "" and cEvent.ID.left(4) <> "auto" Then
		    DeletedIDs.Add cEvent.ID
		  End If
		  
		  Dim idx As Integer = Events.IndexOf(cEvent)
		  
		  If idx > -1 then
		    Events.RemoveAt(idx)
		    Redim DisplayEvents(-1)
		    Redisplay
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveEventByID(EventIDs() As String)
		  //Removes the passed CalendarEvent from the CalendarView
		  //If RemoveFromDB is True, next time ExportToDB is called, all removed events will also be removed from the Database
		  
		  
		  Dim uEvents As Integer = Events.LastIndex
		  Dim uIDs As Integer = EventIds.LastIndex
		  Dim cEvent As CalendarEvent
		  
		  Dim ms As Double = System.Microseconds
		  
		  Dim i As Integer
		  
		  Freeze = True
		  Dim cnt As Integer
		  
		  Dim dicIDs As New Dictionary
		  For i = 0 to uIDs
		    dicIDs.Value(EventIDs(i)) = ""
		  Next
		  
		  for i = uEvents DownTo 0
		    
		    cEvent = me.Events(i)
		    
		    If dicIDs.HasKey(cEvent.ID) then
		      cnt = cnt + 1
		      RemoveEvent(cEvent)
		      dicIDs.Remove(cEvent.ID)
		      If dicIDs.KeyCount = 0 then Exit for i
		    End If
		  next
		  
		  'For j = uIDs DownTo 0
		  '
		  'For i = 0 to uEvents
		  'cEvent = me.Events(i)
		  '
		  'If cEvent.ID = EventIds(j) then
		  'RemoveEvent(cEvent)
		  'cnt = cnt + 1
		  'uEvents = Events.LastIndex
		  'End If
		  'Next
		  'Next
		  System.DebugLog str((System.Microseconds-ms)/1000) + "ms" + EndOfLine + "Removed: " + str(cnt) + " events"
		  
		  //Now Refresh the view
		  
		  Freeze = False
		  me.Redisplay()
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveEventByID(EventID As String, ParamArray MoreIDs As String)
		  //Removes the passed CalendarEvent from the CalendarView
		  //If RemoveFromDB is True, next time ExportToDB is called, all removed events will also be removed from the Database
		  
		  If MoreIDs is Nil then
		    MoreIds() = Array(EventID)
		  End If
		  
		  MoreIDs.AddAt(0, EventID)
		  
		  RemoveEventByID(MoreIDs)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Scroll(deltaX As Integer, deltaY As Integer = 0)
		  //Scrolls the view according to the passed parameters.
		  
		  If deltaX = 0 And deltaY = 0 Then
		    Return
		  End If
		  
		  'If ViewType = TypePicker then
		  'Return
		  'End If
		  
		  If ViewType = TypeYear Then
		    'DisplayDate.Day = 1
		    
		    'DisplayDate.Year = DisplayDate.Year + deltaX
		    DisplayDate = DisplayDate + New DateInterval(deltaX) - New DateInterval(0,0,DisplayDate.Day)
		    
		    ViewChanged
		    
		    FullRefresh = True
		    
		  Elseif ViewType = TypeMonth or ViewType = TypePicker Then
		    'DisplayDate.Day = 1
		    
		    'DisplayDate.Month = DisplayDate.Month + deltaX
		    DisplayDate = DisplayDate + New DateInterval(0,deltaX) - New DateInterval(0,0,DisplayDate.Day)
		    
		    ViewChanged
		    
		    FullRefresh = True
		    
		  Elseif ViewType > TypeMonth Then
		    
		    Dim lastDay As Integer = DisplayDate.Day
		    Dim lastScroll As Double = mScrollPosition
		    
		    If ViewType = TypeOther And ViewDays = 5 Then
		      'DisplayDate.Day = DisplayDate.Day + deltaX * 7
		      DisplayDate = DisplayDate + New DateInterval(0,0,deltaX * 7)
		    Else
		      'DisplayDate.Day = DisplayDate.Day + deltaX * ViewDays
		      DisplayDate = DisplayDate + New DateInterval(0,0,deltaX * ViewDays)
		    End If
		    
		    If Abs(deltaY) > (Me.Height-ViewHeight)\HourHeight And DeltaY <> 0 Then
		      ScrollPosition = ScrollPosition + Abs(deltaY)/deltaY
		    Elseif deltaY <> 0 then
		      ScrollPosition = ScrollPosition + deltaY
		    End If
		    
		    FullRefresh = True
		    
		    If DisplayDate.Day = lastDay And lastScroll = mScrollPosition Then
		      FullRefresh = False
		      Return
		    Elseif DisplayDate.Day <> lastDay Then
		      ViewChanged
		    End If
		  End If
		  
		  If DragEvent = DragMove and LastMouseOver <> Nil then
		    HandleDragEvent(LastX, LastY)
		  End If
		  
		  If Animate then
		    oldBuffer = Buffer
		    AnimationInProgress = DeltaX
		  End If
		  
		  'Invalidate(False)
		  
		  #if TargetDesktop
		    Refresh(False)
		  #elseif TargetWeb
		    Redisplay()
		  #endif
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Search(txt As String, setFocus As Boolean = True, FromBeginning As Boolean = False) As CalendarEvent
		  //newinversion 1.4.0
		  //Searches through all events to find the passed txt string in the event
		  //If no CalendarEvent matching the search term is found, Nil is returned
		  
		  Dim dFirst, dLast As DateTime
		  dFirst = New DateTime(FirstDate)
		  dLast = New DateTime(Today.Year + 20)
		  
		  If FromBeginning then
		    LastSearchResult=Nil
		    dFirst = New DateTime(1, TimeZone.Current)
		    'dFirst.SecondsFrom1970 = 1
		    EventsSorted = False
		  elseif LastSearchResult <> Nil then
		    dFirst = new DateTime(LastSearchResult.StartDate)
		  End If
		  
		  //First we sort events
		  'If not EventsSorted then
		  'LastSearchResult=Nil
		  SortEvents(dFirst, dLast)
		  'EventsSorted = True
		  'End If
		  
		  Dim i As Integer
		  Dim U As Integer = DisplayEvents.LastIndex
		  Dim cEvent As CalendarEvent
		  Dim foundID As Integer = -1
		  
		  
		  //Searching through all events
		  For i = 0 to U
		    cEvent = DisplayEvents(i)
		    
		    If LastSearchResult <> Nil and cEvent.StartDate < LastSearchResult.StartDate then
		      Continue
		    End If
		    
		    If cEvent <> LastSearchResult then
		      If cEvent.Title.IndexOf(txt)>0 then
		        foundID = i
		        exit
		      elseif cEvent.Description.IndexOf(txt)>0 then
		        foundID = i
		        Exit
		      elseif cEvent.Location.IndexOf(txt)>0 then
		        foundID = i
		        Exit
		      End If
		    End If
		  Next
		  
		  //If found a match we return the result
		  If foundID > -1 then
		    LastSearchResult = cEvent
		    If setFocus then
		      FocusOn(cEvent)
		    End If
		    
		    Return cEvent
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub SetDayColor()
		  //In DebugBuild we check performance of drawing
		  #If DebugBuild
		    Dim ms As Double = System.Microseconds
		  #EndIf
		  
		  //Sets the Day Colors for each day in the year depending on the events
		  
		  Dim DrawDate As New DateTime(FirstDate)
		  Dim amount As Integer
		  Dim i, j As Integer
		  Dim idx As Integer
		  Dim u As Integer
		  Dim E As CalendarEvent
		  
		  Redim DayColor(-1)
		  Redim DayColor(366)
		  
		  
		  //Heat Map
		  If YearHeatMap Then
		    
		    SortEvents(FirstDate, LastDate)
		    u = DisplayEvents.LastIndex
		    
		    Dim EventsPerDay(366) As Integer
		    Dim maxVal As Integer
		    
		    If u > -1 Then
		      For i = 1 To 366
		        amount = 0
		        For j = idx To u
		          
		          E = DisplayEvents(j)
		          
		          If DrawDate.SecondsFrom1970+86399 < DisplayEvents(j).StartSeconds Then
		            If amount = 0 Then
		              idx = j
		            End If
		            Exit For j
		          Elseif DrawDate.SecondsFrom1970 <= DisplayEvents(j).EndSeconds Then
		            amount = amount + 1
		          End If
		          
		        Next
		        
		        EventsPerDay(i) = amount
		        maxVal = Max(maxVal, amount)
		        'DrawDate.Day = DrawDate.Day + 1
		        DrawDate = DrawDate + DIDay
		      Next
		    End If
		    
		    For i = 1 To 366
		      
		      If EventsPerDay(i) > 0 Then
		        If EventsPerDay(i) = 1 Then
		          DayColor(i) = New CalendarYearColors(HSV(0.16, 1, 1))
		        Else
		          DayColor(i) = New CalendarYearColors(HSV(0.14-0.14*EventsPerDay(i)/maxVal, 0.5, 1))
		        End If
		      Else
		        'DayColor(i) = &c0
		      End If
		    Next
		    
		  Else //Regular view
		    
		    SortEvents(FirstDate, LastDate, False, Not YearMultipleEvents)
		    u = DisplayEvents.LastIndex
		    
		    For i = 1 To 366
		      
		      For j = Idx To U
		        
		        If DrawDate.SecondsFrom1970+86399 < DisplayEvents(j).StartSeconds Then
		          If YearMultipleEvents = False then
		            Idx = j
		          End If
		          Exit For j
		        Elseif DrawDate.SecondsFrom1970 <= DisplayEvents(j).EndSeconds Then
		          If DayColor(i) is Nil then
		            DayColor(i) = New CalendarYearColors(DisplayEvents(j).EventColor)
		          else
		            DayColor(i).AppendColor(DisplayEvents(j).EventColor)
		          End If
		          'DayColor(i) = DisplayEvents(j).EventColor
		          If YearMultipleEvents = False then
		            Exit For j
		          End If
		        else
		          Idx = j
		          'Exit for j
		        End If
		      Next
		      
		      'DrawDate.Day = DrawDate.Day + 1
		      DrawDate = DrawDate + DIDay
		    Next
		  End If
		  
		  #If DebugBuild
		    ms = (System.Microseconds-ms)/1000
		    DrawInfo = Str(ms)
		  #EndIf
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetStyle(StyleType As Integer)
		  //Sets the StyleType
		  //See the Style constants of the CalendarView for the StyleType accepted values.
		  
		  mStyle = StyleType
		  
		  EraseBuffers()
		  
		  Dim DefaultTextSize As Integer
		  
		  #if TargetDesktop
		    Dim FillColor As Color = Color.FillColor
		    #If TargetMacOS Then
		      FillColor = &cEDEDED
		    #EndIf
		    DefaultTextSize = 0
		  #elseif TargetWeb
		    Dim FillColor As Color = &cEDEDED
		    Dim HighlightColor As Color = &cA6CAFE
		    DefaultTextSize = 12
		  #endif
		  
		  MyStyle.StringValue(True) = ""
		  
		  //applies to all styles:
		  MyStyle.MTitleTextSize = 20
		  MyStyle.MNumbersTextSize = DefaultTextSize
		  MyStyle.YTitleTextSize = 10
		  MyStyle.YNumbersTextSize = 9
		  MyStyle.WTextSize = DefaultTextSize
		  MyStyle.PTextSize = DefaultTextSize
		  
		  If StyleType = StyleDefault Then
		    MyStyle.MDayTextBold = False
		    MyStyle.MDayTextColor = &c0
		    MyStyle.MDayTransparent = False
		    MyStyle.MDayTransparency = &cAAAAAA
		    MyStyle.MDayRoundRect = True
		    MyStyle.MEventHeight = 12
		    MyStyle.MEventTextSize = 10
		    MyStyle.MLeftOffset = 0
		    MyStyle.MTextOffset = 3
		    MyStyle.MHourBold = True
		    MyStyle.MTextBold = False
		    MyStyle.MDayNumberAlign = AlignRight
		    MyStyle.MDayNameAlign = AlignCenter
		    MyStyle.MNumberXOffset = 3
		    MyStyle.MNumberYOffset = 0
		    
		    MyStyle.WEventHeight = 18
		    MyStyle.MColorOffset1 = 8
		    MyStyle.MColorOffset2 = 40
		    MyStyle.MEventFill = FillGradientHorizontal
		    MyStyle.MBorderSolid = True
		    MyStyle.MDayNumberBackground = False
		    MyStyle.MColorOtherMonth = False
		    MyStyle.MFirstDayOfMonthName = True
		    MyStyle.MFirstDayOfMonthBold = False
		    
		    MyColors.WeekNumber = &cFFFFFF
		    MyColors.WeekNumberBackground = &c7799BB
		    MyColors.Border = &cCCCCCC
		    MyColors.Line = &cCCCCCC
		    MyColors.Title = &c505050
		    MyColors.DayName = &c757575
		    MyColors.DayNumber = &cA9A9A9
		    MyColors.DayNumberActive = &c2B2B2B
		    MyColors.TimeBackground = &cEDEDED
		    MyColors.TimeBackground = FillColor
		    MyColors.Time = &c9B9C9D
		    MyColors.Today = &cEAF0F9
		    MyColors.Header = FillColor
		    MyColors.Selected = &cFFF0F0
		    MyColors.WeekDay = &cFFFFFF
		    MyColors.Weekend = &cF0FAF0
		    MyColors.YBackground = FillColor
		    
		    MyColors.PDayNumber = &cA9A9A9
		    MyColors.PDayNumberActive = &c2B2B2B
		    MyColors.PSelected = &cEEEEEE
		    MyColors.POver = &cEEEEEE
		    MyColors.PBackground = &cFFFFFF
		    MyColors.PArrow = &c505050
		    MyStyle.PDayNumberBold = False
		    MyStyle.PLineHorizontal = LineNone
		    MyStyle.PLineVertical = LineThinDotted
		    
		    MyStyle.WTodayHeader = False
		    MyStyle.WHeaderColorOffset = 0
		    MyStyle.WHeaderHeight = 13 //a corriger
		    MyStyle.WRoundRect = True
		    MyStyle.WHeaderTransparency = &c0
		    MyStyle.WBodyTransparency = &c0
		    MyStyle.WHeaderTextBold = False
		    MyStyle.WHeaderTextSize = 10
		    MyStyle.WHeaderTextFormat = "%Start (%Length)"
		    MyStyle.WTimeVOffset = 0
		    MyStyle.WTimeAlign = AlignRight
		    MyStyle.WBodyTextBold = False
		    MyStyle.WBodyTextSize = 10
		    MyStyle.WBodyColorOffset1 = 8
		    MyStyle.WBodyColorOffset2 = 40
		    MyStyle.WEventFill = FillGradientHorizontal
		    MyStyle.WAutoTextColor = False
		    MyStyle.WTextColor = &c0
		    MyStyle.WHourLineStartX=TimeWidth
		    MyStyle.WHalfHourLineStyle = 1
		    MyStyle.WHalfHourColorOffset = &h10
		    MyColors.WDefaultColor = Color.HighlightColor
		    MyStyle.YLineHorizontal = LineThinSolid
		    MyStyle.YLineVertical = LineThinSolid
		    
		    MyStyle.PDayNamePos = 1
		    MyStyle.PDayNumberPos = 1
		    MyStyle.PDayNameBold = True
		    
		    
		  Elseif StyleType = StyleICal Then //iCal
		    MyStyle.MDayTextBold = False
		    MyStyle.MDayTextColor = &cFFFFFF
		    MyStyle.MDayTransparent = True
		    MyStyle.MDayTransparency = &c868686
		    MyStyle.MDayRoundRect = True
		    MyStyle.MEventHeight = 12
		    MyStyle.MEventTextSize = 10
		    MyStyle.MLeftOffset = 0
		    MyStyle.MTextOffset = 3
		    MyStyle.MHourBold = True
		    MyStyle.MTextBold = False
		    MyStyle.MDayNumberAlign = AlignRight
		    MyStyle.MDayNameAlign = 3
		    MyStyle.MColorOffset1 = 0
		    MyStyle.MColorOffset2 = 0
		    MyStyle.MBorderSolid = False
		    MyStyle.MDayNumberBackground = False
		    MyStyle.MColorOtherMonth = False
		    MyStyle.MFirstDayOfMonthName = False
		    MyStyle.MFirstDayOfMonthBold = False
		    MyStyle.MNumberXOffset = 3
		    MyStyle.MNumberYOffset = 0
		    
		    
		    MyColors.WeekNumber = &cFFFFFF
		    MyColors.WeekNumberBackground = &c777777
		    MyColors.Border = &cCCCCCC
		    MyColors.Line = &cCCCCCC
		    MyColors.Title = &c505050
		    MyColors.DayName = &c757575
		    MyColors.DayNumber = &cA9A9A9
		    MyColors.DayNumberActive = &c2B2B2B
		    MyColors.TimeBackground = FillColor
		    MyColors.Time = &c9B9C9D
		    MyColors.Today = &cEAF0F9
		    MyColors.Header = FillColor
		    MyColors.Selected = &cFFF0F0
		    MyColors.WeekDay = &cFFFFFF
		    MyColors.Weekend = &cF0FAF0
		    MyColors.YBackground = FillColor
		    
		    AdaptWeeksPerMonth = True
		    MyColors.PDayNumber = &cFFFFFF
		    MyColors.PDayNumberActive = &c2B2B2B
		    MyColors.PSelected = &cEEEEEE
		    MyColors.POver = &cEEEEEE
		    MyColors.PBackground = &cFFFFFF
		    MyColors.PArrow = &c505050
		    MyStyle.PDayNumberBold = False
		    MyStyle.PLineHorizontal = LineNone
		    MyStyle.PLineVertical = LineNone
		    
		    MyStyle.WTodayHeader = False
		    MyStyle.WEventHeight = 18
		    MyStyle.WHeaderColorOffset = &hD8
		    MyStyle.WHeaderHeight = 0
		    MyStyle.WRoundRect = True
		    MyStyle.WHeaderTransparency = &c0
		    MyStyle.WBodyTransparency = &c777777
		    MyStyle.WBodyColorOffset1 = 0
		    MyStyle.WBodyColorOffset2 = 0
		    MyStyle.WHeaderTextBold = False
		    MyStyle.WHeaderTextSize = 10
		    MyStyle.WHeaderTextFormat = "%Start"
		    MyStyle.WTimeVOffset = 0
		    MyStyle.WTimeAlign = AlignRight
		    MyStyle.WBodyTextBold = False
		    MyStyle.WBodyTextSize = 11
		    MyStyle.WAutoTextColor = True
		    MyStyle.WHourLineStartX = TimeWidth
		    MyStyle.WHalfHourLineStyle = 0
		    MyStyle.WHalfHourColorOffset = &h10
		    MyColors.WDefaultColor = Color.HighlightColor
		    MyStyle.YLineHorizontal = LineThinSolid
		    MyStyle.YLineVertical = LineThinSolid
		    
		    MyStyle.PDayNamePos = 1
		    MyStyle.PDayNumberPos = 1
		    MyStyle.PDayNameBold = True
		    
		  Elseif StyleType = StyleGoogle Then //Google Calendar
		    MyStyle.MDayTextBold = False
		    MyStyle.MDayTextColor = &c777777
		    MyStyle.MDayTransparent = False
		    MyStyle.MDayTransparency = &c0
		    MyStyle.MDayRoundRect = False
		    MyStyle.MEventHeight = 20
		    MyStyle.MEventTextSize = 12
		    MyStyle.MLeftOffset = 2
		    MyStyle.MTextOffset = 5
		    MyStyle.MHourBold = True
		    MyStyle.MTextBold = False
		    MyStyle.MDayNumberAlign = AlignLeft
		    MyStyle.MDayNameAlign = AlignLeft
		    MyStyle.MColorOffset1 = 0
		    MyStyle.MColorOffset2 = 0
		    MyStyle.MEventFill = FillSolid
		    MyStyle.MBorderSolid = False
		    MyStyle.MDayNumberBackground = False
		    MyStyle.MColorOtherMonth = False
		    MyStyle.MFirstDayOfMonthName = False
		    MyStyle.MFirstDayOfMonthBold = False
		    MyStyle.MNumberXOffset = 3
		    MyStyle.MNumberYOffset = 0
		    
		    MyColors.WeekNumber = &cFFFFFF
		    MyColors.WeekNumberBackground = &c7799BB
		    MyColors.Border = &cCCCCCC
		    MyColors.Line = &cCCCCCC
		    MyColors.Title = &c505050
		    MyColors.DayName = &c757575
		    MyColors.DayNumber = &cA9A9A9
		    MyColors.DayNumberActive = &c2B2B2B
		    MyColors.Time = &c9B9C9D
		    MyColors.TimeBackground = &cFFFFFF
		    MyColors.Today = &cEAF0F9
		    MyColors.Header = FillColor
		    MyColors.Selected = &cFFF0F0
		    MyColors.WeekDay = &cFFFFFF
		    MyColors.Weekend = &cF0FAF0
		    MyColors.YBackground = FillColor
		    
		    MyColors.PSelected = &cEEEEEE
		    MyColors.POver = &cEEEEEE
		    MyColors.PBackground = &cFFFFFF
		    MyColors.PArrow = &c8B8D8A
		    MyColors.PDayNumber = &cA9A9A9
		    MyColors.PDayNumberActive = &c2B2B2B
		    MyStyle.PDayNumberBold = False
		    MyStyle.PLineHorizontal = LineNone
		    MyStyle.PLineVertical = LineNone
		    
		    
		    MyStyle.WEventHeight = 20
		    MyStyle.WHeaderColorOffset = &hD8
		    MyStyle.WHeaderHeight = 0
		    MyStyle.WHeaderTransparency = &c0
		    MyStyle.WBodyColorOffset1 = 0
		    MyStyle.WBodyColorOffset2 = 0
		    MyStyle.WBodyTransparency = &c0
		    MyStyle.WRoundRect = False
		    
		    MyStyle.WTodayHeader = False
		    MyStyle.WHeaderTextBold = True
		    MyStyle.WHeaderTextSize = 10
		    MyStyle.WHeaderTextFormat = "%Start - %End"
		    MyStyle.WTimeVOffset = 10
		    MyStyle.WTimeAlign = AlignRight
		    MyStyle.WBodyTextBold = False
		    MyStyle.WBodyTextSize = DefaultTextSize
		    MyStyle.WAutoTextColor = False
		    MyStyle.WTextColor = &c1D1D1D
		    MyStyle.WHourLineStartX = 1
		    MyStyle.WHalfHourLineStyle = 1
		    MyStyle.WHalfHourColorOffset = &h10
		    MyColors.WDefaultColor = &c4986E7
		    MyStyle.YLineHorizontal = LineThinSolid
		    MyStyle.YLineVertical = LineThinSolid
		    
		    MyStyle.PDayNamePos = 1
		    MyStyle.PDayNumberPos = 1
		    MyStyle.PDayNameBold = False
		    
		  Elseif StyleType = StyleDark Then
		    MyStyle.MDayTextBold = True
		    MyStyle.MDayTextColor = &c999999
		    MyStyle.MDayTransparent = False
		    MyStyle.MDayTransparency = &cAAAAAA
		    MyStyle.MDayRoundRect = True
		    MyStyle.MEventHeight = 12
		    MyStyle.MEventTextSize = 10
		    MyStyle.MLeftOffset = 0
		    MyStyle.MTextOffset = 3
		    MyStyle.MHourBold = True
		    MyStyle.MTextBold = True
		    MyStyle.MDayNumberAlign = AlignRight
		    MyStyle.MDayNameAlign = AlignCenter
		    MyStyle.MNumberXOffset = 3
		    MyStyle.MNumberYOffset = 0
		    
		    MyStyle.WEventHeight = 18
		    MyStyle.MColorOffset1 = 8
		    MyStyle.MColorOffset2 = 40
		    MyStyle.MEventFill = FillGradientHorizontal
		    MyStyle.MBorderSolid = True
		    MyStyle.MDayNumberBackground = False
		    MyStyle.MColorOtherMonth = False
		    MyStyle.MFirstDayOfMonthName = False
		    MyStyle.MFirstDayOfMonthBold = False
		    
		    MyColors.WeekNumber = &cFFFFFF
		    MyColors.WeekNumberBackground = &c7799BB
		    MyColors.Border = &c353535
		    MyColors.Line = &c000000
		    MyColors.Title = &cCCFF35
		    MyColors.DayName = &c999999
		    MyColors.DayNumber = &c323232
		    MyColors.DayNumberActive = &cFEFEFE
		    MyColors.TimeBackground = &c161616
		    MyColors.Time = &c999999
		    MyColors.Today = &c93C400
		    MyColors.Header = &c161616
		    MyColors.Selected = &c2E3614
		    MyColors.WeekDay = &c161616
		    MyColors.Weekend = &c1E1E1E
		    MyColors.YBackground = &cCCCCCC
		    Me.ColorWeekend = False
		    
		    
		    MyColors.PDayNumber = &c323232
		    MyColors.PDayNumberActive = &cFEFEFE
		    MyColors.PSelected = &c2E3614
		    MyColors.POver = &c2E3614
		    MyColors.PBackground = &c161616
		    MyColors.PArrow = &c999999
		    MyColors.line2 = &c2B2B2B
		    MyStyle.PDayNumberBold = True
		    MyStyle.PLineHorizontal = LineNone
		    MyStyle.PLineVertical = LineThinDouble
		    
		    MyStyle.WTodayHeader = False
		    MyStyle.WHeaderColorOffset = 0
		    MyStyle.WHeaderHeight = 13 //a corriger
		    MyStyle.WRoundRect = True
		    MyStyle.WHeaderTransparency = &c0
		    MyStyle.WBodyTransparency = &c0
		    MyStyle.WHeaderTextBold = True
		    MyStyle.WHeaderTextSize = 9
		    MyStyle.WHeaderTextFormat = "%Start (%Length)"
		    MyStyle.WTimeVOffset = 0
		    MyStyle.WBodyTextBold = False
		    MyStyle.WBodyTextSize = 10
		    MyStyle.WBodyColorOffset1 = 8
		    MyStyle.WBodyColorOffset2 = 40
		    MyStyle.WEventFill = FillGradientHorizontal
		    MyStyle.WAutoTextColor = False
		    MyStyle.WTextColor = &c0
		    MyStyle.WHourLineStartX = TimeWidth
		    MyStyle.WHalfHourLineStyle = 1
		    MyStyle.WHalfHourColorOffset = &h10
		    MyColors.WDefaultColor = Color.HighlightColor
		    MyStyle.YLineHorizontal = LineNone
		    MyStyle.YLineVertical = LineThinDouble
		    
		    MyStyle.PDayNamePos = 1
		    MyStyle.PDayNumberPos = 1
		    MyStyle.PDayNameBold = True
		    
		    
		  Elseif StyleType = StyleOutlook2010 Then
		    MyStyle.MDayTextBold = False
		    MyStyle.MDayTextColor = &c3B3B3B
		    MyStyle.MDayTransparent = False
		    MyStyle.MDayTransparency = &c0
		    MyStyle.MDayRoundRect = False
		    MyStyle.MEventHeight = 19
		    MyStyle.MEventTextSize = 10
		    MyStyle.MLeftOffset = 0
		    MyStyle.MTextOffset = 3
		    MyStyle.MHourBold = False
		    MyStyle.MTextBold = False
		    MyStyle.MDayNumberAlign = AlignLeft
		    MyStyle.MDayNameAlign = AlignCenter
		    MyStyle.MNumberXOffset = 3
		    MyStyle.MNumberYOffset = 0
		    
		    MyStyle.WEventHeight = 19
		    MyStyle.MColorOffset1 = 60
		    MyStyle.MColorOffset2 = 8
		    MyStyle.MEventFill = FillGradientVertical
		    MyStyle.MBorderSolid = True
		    MyStyle.MDayNumberBackground = True
		    MyStyle.MFirstDayOfMonthName = False
		    MyStyle.MFirstDayOfMonthBold = False
		    
		    MyColors.WeekNumber = &c3B3B3B
		    MyColors.WeekNumberBackground = &cA5BFE1
		    MyColors.Border = &cCCCCCC
		    MyColors.Line = &cA5BFE1
		    MyColors.Title = &c505050
		    MyColors.DayName = &c3B3B3B
		    MyColors.DayNumber = &c808080
		    MyColors.DayNumberActive = &c3B3B3B
		    MyColors.DayNumberBackground = &cCEDBEF
		    MyColors.Time = &c3B3B3B
		    MyColors.TimeBackground = &cFFFFFF
		    MyColors.Today = &cFFF8BF
		    MyColors.Header = &cA5BFE1
		    MyColors.Selected = &cFFF0F0
		    MyColors.WeekDay = &cFFFFFF
		    MyColors.Weekend = &cE6EDF7
		    MyColors.YBackground = FillColor
		    MyColors.OtherMonth = &cCEDBEF
		    
		    MyColors.PDayNumber = &c808080
		    MyColors.PDayNumberActive = &c3B3B3B
		    MyColors.PSelected = &cEEEEEE
		    MyColors.POver = &cEEEEEE
		    MyColors.PBackground = &cFFFFFF
		    MyColors.PArrow = &c0
		    MyStyle.PDayNumberBold = False
		    MyStyle.PLineHorizontal = LineNone
		    MyStyle.PLineVertical = LineNone
		    
		    MyStyle.WTodayHeader = False
		    MyStyle.WHeaderColorOffset = 0
		    MyStyle.WHeaderHeight = 0
		    MyStyle.WRoundRect = False
		    MyStyle.WHeaderTransparency = &c0
		    MyStyle.WBodyTransparency = &c0
		    MyStyle.WHeaderTextBold = True
		    MyStyle.WHeaderTextSize = 10
		    MyStyle.WHeaderTextFormat = "%Start - %End"
		    MyStyle.WTimeVOffset = 0
		    MyStyle.WTimeAlign = AlignLeft
		    MyStyle.WBodyTextBold = False
		    MyStyle.WBodyTextSize = 10
		    MyStyle.WBodyColorOffset1 = 60
		    MyStyle.WBodyColorOffset2 = 8
		    MyStyle.WEventFill = FillGradientVertical
		    MyStyle.WAutoTextColor = False
		    MyStyle.WTextColor = &c0
		    MyStyle.WHourLineStartX = TimeWidth
		    MyStyle.WHalfHourLineStyle = 0
		    MyStyle.WHalfHourColorOffset = &h49
		    MyColors.WDefaultColor = &c8DAED9
		    MyStyle.MColorOtherMonth = True
		    MyStyle.YLineHorizontal = LineThinSolid
		    MyStyle.YLineVertical = LineThinSolid
		    
		    MyStyle.PDayNamePos = 1
		    MyStyle.PDayNumberPos = 1
		    MyStyle.PDayNameBold = True
		    
		    
		  Elseif StyleType = StyleOutlook2013 Then
		    MyStyle.MDayTextBold = True
		    MyStyle.MDayTextColor = &c444444
		    MyStyle.MDayTransparent = False
		    MyStyle.MDayTransparency = &c0
		    MyStyle.MDayRoundRect = False
		    MyStyle.MEventHeight = 19
		    MyStyle.MEventTextSize = 10
		    MyStyle.MLeftOffset = 1
		    MyStyle.MTextOffset = 13
		    MyStyle.MHourBold = False
		    MyStyle.MTextBold = False
		    MyStyle.MDayNumberAlign = AlignLeft
		    MyStyle.MDayNameAlign = AlignLeft
		    MyStyle.MNumberXOffset = 9
		    MyStyle.MNumberYOffset = 5
		    MyStyle.MHasSelectedTextColor = True
		    MyColors.MSelectedText = &cFFFFFF
		    
		    If MyColors.MainColor = &c0 then
		      MyColors.MainColor = &c99C8E9
		    End If
		    
		    
		    MyStyle.WEventHeight = 19
		    MyStyle.MColorOffset1 = 52
		    MyStyle.MColorOffset2 = 8
		    MyStyle.MEventFill = FillOutlook2013
		    MyStyle.MBorderSolid = False
		    MyStyle.MDayNumberBackground = False
		    MyStyle.MFirstDayOfMonthName = True
		    MyStyle.MFirstDayOfMonthBold = True
		    
		    MyColors.WeekNumber = &c3B3B3B
		    MyColors.WeekNumberBackground = MyColors.MainColor
		    MyColors.Border = &cCCCCCC
		    MyColors.Line = &cE1E1E1
		    MyColors.Title = &c505050
		    MyColors.DayName = &c3B3B3B
		    MyColors.DayNumber = &c444444
		    MyColors.DayNumberActive = &c444444
		    MyColors.DayNumberBackground = &cCEDBEF
		    MyColors.Time = &c3B3B3B
		    MyColors.TimeBackground = &cFFFFFF
		    MyColors.Today = &cFFF8BF
		    MyColors.Header = &cA5BFE1
		    MyColors.Selected = &cFFF0F0
		    MyColors.WeekDay = &cFFFFFF
		    MyColors.Weekend = &cF2F2F2
		    MyColors.YBackground = FillColor
		    MyColors.OtherMonth = &cCEDBEF
		    
		    MyColors.PDayNumber = &c444444
		    MyColors.PDayNumberActive = &c444444
		    MyColors.PSelected = &cCDE6F7
		    MyColors.POver = &c0072C6
		    MyColors.PBackground = &cFFFFFF
		    MyColors.PArrow = &c444444
		    MyStyle.PDayNumberBold = False
		    MyStyle.PLineHorizontal = LineNone
		    MyStyle.PLineVertical = LineNone
		    MyColors.PDayNumberToday = &cFFFFFF
		    
		    MyColors.Today = MyColors.MainColor
		    MyColors.Selected = MyColors.MainColor
		    MyColors.Header = ShiftColor(MyColors.MainColor, MyStyle.MColorOffset1)
		    If ViewType = TypePicker then
		      MyColors.Today = &c0072C6
		      MyColors.Header = &cF0F0F0
		      HeaderHeight = 22
		    End If
		    
		    ColorWeekend = True
		    
		    Dim D As DateTime
		    'D.Hour = 1
		    D = DateTime.Now 
		    D = New DateTime(D.Year, D.Month, D.Day, 1, 0, 0)
		    
		    If D.ToString(DateTime.FormatStyles.None, DateTime.FormatStyles.Short).IndexOf("AM")>0 or ForceAM_PM then
		      MyStyle.WTimeFormat = "HH (A)"
		    else
		      MyStyle.WTimeFormat = "HH"
		    End If
		    MyStyle.WTodayHeader = True
		    MyStyle.WHeaderColorOffset = 0
		    MyStyle.WHeaderHeight = 0
		    MyStyle.WRoundRect = False
		    MyStyle.WHeaderTransparency = &c0
		    MyStyle.WBodyTransparency = &c0
		    MyStyle.WHeaderTextBold = True
		    MyStyle.WHeaderTextSize = 10
		    MyStyle.WHeaderTextFormat = ""
		    MyStyle.WTimeVOffset = 10
		    MyStyle.WTimeAlign = AlignLeft
		    MyStyle.WBodyTextBold = True
		    MyStyle.WBodyTextSize = 12
		    MyStyle.WBodyColorOffset1 = 60
		    MyStyle.WBodyColorOffset2 = 8
		    MyStyle.WEventFill = FillOutlook2013
		    MyStyle.WAutoTextColor = False
		    MyStyle.WTextColor = &c0
		    MyStyle.WHourLineStartX = 5
		    MyStyle.WHalfHourLineStyle = LineThinDotted
		    MyStyle.WHalfHourColorOffset = 0
		    MyColors.WDefaultColor = MyColors.MainColor
		    MyStyle.MColorOtherMonth = False
		    MyStyle.YLineHorizontal = LineThinSolid
		    MyStyle.YLineVertical = LineThinSolid
		    
		    MyStyle.PDayNamePos = 1
		    MyStyle.PDayNumberPos = 1
		    MyStyle.PDayNameBold = True
		    
		  End If
		  
		  #if TargetDesktop
		    FullRefresh = True
		    Me.Refresh(False)
		  #elseif TargetWeb
		    me.Redisplay()
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub SetupCSS()
		  #if TargetWeb
		    styles(0).value("visibility") = "visible" // Every WebSDK control needs this
		    
		    Dim st As WebControlCSS
		    
		    //------------Date Picker and Year------------
		    st = new WebControlCSS
		    st.Selector = "." + self.ControlID + "_dp_cell"
		    st.Value("text-align") = "center"
		    st.Value("padding") = "2px"
		    Styles.Append st
		    
		    st = new WebControlCSS
		    st.Selector = "." + self.ControlID + "_dp_dayNbr"
		    st.Value("border-left") = "dashed 1px #B6B6B6"
		    Styles.Append st
		    
		    st = new WebControlCSS
		    st.Selector = "." + self.ControlID + "_dp_dayNbr:hover"
		    st.Value("background-color") = "#EEE"
		    Styles.Append st
		    
		    st = new WebControlCSS
		    st.Selector = "." + self.ControlID + "_dp_Today"
		    st.Value("background-color") = "#EAF0F9"
		    Styles.Append st
		    
		    st = new WebControlCSS
		    st.Selector = "." + self.ControlID + "_dp_title"
		    st.Value("text-align") = "center"
		    st.Value("font-weight") = "bold"
		    st.Value("font-size") = "1.1em"
		    Styles.Append st
		    
		    st = new WebControlCSS
		    st.Selector = "." + self.ControlID + "_dp_dayName"
		    st.Value("font-weight") = "bold"
		    st.Value("border-bottom") = "solid 1px #CCC"
		    Styles.Append st
		    
		    st = new WebControlCSS
		    st.Selector = "." + self.ControlID + "_dp_onmonth"
		    st.Value("color") = "#222"
		    Styles.Append st
		    
		    st = new WebControlCSS
		    st.Selector = "." + self.ControlID + "_dp_offmonth"
		    st.Value("color") = "#999"
		    Styles.Append st
		    
		    st = new WebControlCSS
		    st.Selector = "." + self.ControlID + "_dp_dayLeft"
		    st.Value("border-left") = "0px"
		    Styles.Append st
		    
		    st = new WebControlCSS
		    st.Selector = "." + self.ControlID + "_dp_dayRight"
		    st.Value("border-right") = "0px"
		    Styles.Append st
		    
		    st = new WebControlCSS
		    st.Selector = "." + self.ControlID + "_dp_weekday"
		    'st.Value("border-right") = "0px"
		    Styles.Append st
		    
		    st = new WebControlCSS
		    st.Selector = "." + self.ControlID + "_dp_weekend"
		    st.Value("background-color") = "#F0FAF0"
		    Styles.Append st
		    
		    //------------Year------------
		    
		    st = new WebControlCSS
		    st.Selector = "." + self.ControlID + "_y_table"
		    st.Value("border") = "solid 1px #CCC"
		    st.Value("background-color") = "#FFF"
		    Styles.Append st
		    
		    //------------Month------------
		    
		    st = new WebControlCSS
		    st.Selector = "." + self.ControlID + "_m_header"
		    st.Value("background-color") = FormatColor(me.MyColors.Header)
		    'st.Value("border-left") = "solid 1px #000"
		    Styles.Append st
		    
		    st = new WebControlCSS
		    st.Selector = "." + self.ControlID + "_m_title"
		    st.Value("font-weight") = "bold"
		    st.Value("text-size") = str(MyStyle.MTitleTextSize) + "px"
		    st.Value("text-align") = "center"
		    Styles.Append st
		    
		    st = new WebControlCSS
		    st.Selector = "." + self.ControlID + "_m_dayname"
		    st.Value("text-align") = "center"
		    'st.Value("border-left") = "solid 1px #000"
		    Styles.Append st
		    
		    st = new WebControlCSS
		    st.Selector = "." + self.ControlID + "_m_dayname_today"
		    st.Value("font-weight") = "bold"
		    st.Value("background-color") = FormatColor(MyColors.MainColor)
		    Styles.Append st
		    
		    
		    
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub SetupHTML()
		  #if TargetWeb
		    
		    Dim xStyle As String
		    If me.Style <> Nil then
		      xStyle = " class=""" + me.Style.Name + """ "
		    End If
		    
		    'If Overflow then
		    '//height: " + str(OverflowHeight) + "px
		    Return "<div id=""" + self.ControlID + """" + xStyle + " style=""overflow-y:auto; overflow-x:hidden""></div>"
		    '<img id=""" + self.ControlID + "_img"" src=""""/>
		    'Else
		    'Return "<div id=""" + self.ControlID + """" + xStyle + "></div>"
		    'End If
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetupLocaleInfo()
		  #if TargetWin32
		    
		    Dim i, ret As Integer
		    Dim retVal As String
		    Dim mb as new MemoryBlock( 2048 )
		    
		    //Day Names
		    Const LOCALE_SDAYNAME1 = 42'&h0000002A
		    Const LOCALE_SDAYNAME2 = &h0000002B
		    Const LOCALE_SDAYNAME3 = &h0000002C
		    Const LOCALE_SDAYNAME4 = &h0000002D
		    Const LOCALE_SDAYNAME5 = &h0000002E
		    Const LOCALE_SDAYNAME6 = &h0000002F
		    Const LOCALE_SDAYNAME7 = &h00000030
		    dim dayConst( 7 ) as Integer
		    dayConst = Array( LOCALE_SDAYNAME1, LOCALE_SDAYNAME2, LOCALE_SDAYNAME3, _
		    LOCALE_SDAYNAME4, LOCALE_SDAYNAME5, LOCALE_SDAYNAME6, LOCALE_SDAYNAME7 )
		    
		    for i = 0 to 6
		      ret = GetLocaleInfo( dayConst( i ), mb, retVal )
		      DayNames((i+1) mod 7 +1) = ConvertEncoding(retVal, Encodings.UTF8).Titlecase
		    next
		    
		    //Month Names
		    Const LOCALE_SMONTHNAME1 = 56'&h00000038
		    Const LOCALE_SMONTHNAME2 = &h00000039
		    Const LOCALE_SMONTHNAME3 = &h0000003A
		    Const LOCALE_SMONTHNAME4 = &h0000003B
		    Const LOCALE_SMONTHNAME5 = &h0000003C
		    Const LOCALE_SMONTHNAME6 = &h0000003D
		    Const LOCALE_SMONTHNAME7 = &h0000003E
		    Const LOCALE_SMONTHNAME8 = &h0000003F
		    Const LOCALE_SMONTHNAME9 = &h00000040
		    Const LOCALE_SMONTHNAME10 = &h00000041
		    Const LOCALE_SMONTHNAME11 = &h00000042
		    Const LOCALE_SMONTHNAME12 = &h00000043
		    Const LOCALE_SMONTHNAME13 = &h0000100E
		    dim monthConst( 13 ) as Integer
		    monthConst = Array( LOCALE_SMONTHNAME1, LOCALE_SMONTHNAME2, LOCALE_SMONTHNAME3, _
		    LOCALE_SMONTHNAME4, LOCALE_SMONTHNAME5, LOCALE_SMONTHNAME6, LOCALE_SMONTHNAME7, _
		    LOCALE_SMONTHNAME8, LOCALE_SMONTHNAME9, LOCALE_SMONTHNAME10, LOCALE_SMONTHNAME11, _
		    LOCALE_SMONTHNAME12, LOCALE_SMONTHNAME13 )
		    
		    ReDim MonthNames(12)
		    for i = 0 to 11
		      ret = GetLocaleInfo( monthConst( i ), mb, retVal )
		      MonthNames(i+1) = ConvertEncoding(retVal, Encodings.UTF8).Titlecase
		    next
		    
		    //Day of Week
		    Const LOCALE_IFIRSTDAYOFWEEK  = &h100C
		    ret = GetLocaleInfo( LOCALE_IFIRSTDAYOFWEEK, mb, retVal )
		    FirstDayOfWeek = (Val( retVal ) + 1) mod 7 + 1
		    
		  #else
		    
		    Dim D As DateTime = DateTime.Now
		    
		    For i as integer = 0 to 6
		      DayNames(D.DayOfWeek) = D.ToString(DateTime.FormatStyles.Long, DateTime.FormatStyles.None).NthField(" ", 1).Replace(",", "")
		      D = D + DIDay
		      'D.Day = D.Day + 1
		    Next
		    
		    D = D - New DateInterval(0,d.Month-1,d.Day-1)
		    'D.Day = 1
		    'D.Month = 1
		    Dim MonthField As Integer
		    If IsNumeric(D.ToString(DateTime.FormatStyles.Long, DateTime.FormatStyles.None).NthField(" ", 2)) then
		      MonthField = 3
		    else
		      MonthField = 2
		    End If
		    For i as Integer = 1 to 12
		      MonthNames(i) = D.ToString(DateTime.FormatStyles.Long, DateTime.FormatStyles.None).NthField(" ", MonthField).Replace(",", "").Titlecase
		      D = D + DIMonth 
		      'D.Month = D.Month + 1
		    Next
		    
		    FirstDayOfWeek = 1 //Sunday
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ShiftColor(C As Color, Percent As Single) As Color
		  If Percent = 0.0 then Return C
		  If Percent > 1 then
		    Percent = Percent /100
		  elseif Percent < -1 then
		    Percent = Percent / 100
		  End If
		  
		  If Percent > 0 then
		    Return Color.RGB((255-C.Red)*Percent + C.Red, (255-C.Green)*Percent+C.Green, (255-C.Blue)*Percent + C.Blue)
		  else
		    Return Color.RGB((1+Percent) * C.Red, (1+Percent) * C.Green, (1+Percent) * C.Blue)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1021
		Private Function ShiftColor2(c As Color, shiftValue As Integer) As Color
		  
		  Return Color.RGB(c.Red + shiftValue, c.Green + shiftValue, c.Blue + shiftValue)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub SortEvents(FirstDate As DateTime, EndDate As DateTime, NoRedim As Boolean = False, OnePerDay As Boolean = False)
		  //Sorts all events
		  
		  Dim i, j As Integer
		  Dim u As Integer = Events.LastIndex
		  Dim E As CalendarEvent
		  Dim RecurE() As CalendarEvent
		  
		  #if DebugBuild
		    Dim ms As Double = System.Microseconds
		  #endif
		  
		  If NoRedim = False then
		    Redim DisplayEvents(-1)
		  End If
		  
		  If FilterEvents then
		    For i = 0 to u
		      E = Events(i)
		      If (E.StartDate >= FirstDate and E.StartDate < EndDate) or _
		        ( E.StartDate < FirstDate and E.StartSeconds + E.Length >= FirstDate.SecondsFrom1970) then
		        If CalendarEventFilter(E) then
		          DisplayEvents.Add E
		          
		          If E.Recurrence <> Nil then
		            RecurE = CheckRecurringEvents(E, FirstDate, EndDate)
		            If RecurE is Nil then Continue
		            For j = 0 to RecurE.LastIndex
		              DisplayEvents.Add RecurE(j)
		            Next
		          End If
		        End If
		        
		      Elseif E.Recurrence <> Nil and E.StartDate <= EndDate then
		        
		        RecurE = CheckRecurringEvents(E, FirstDate, EndDate)
		        If RecurE is Nil then Continue
		        For j = 0 to RecurE.LastIndex
		          DisplayEvents.Add RecurE(j)
		        Next
		        
		      End If
		      
		    Next
		    
		  else //No filtering of Events
		    
		    For i = 0 to u
		      E = Events(i)
		      If (E.StartDate >= FirstDate and E.StartDate < EndDate) or _
		        E.StartDate < FirstDate and E.StartSeconds + E.Length >= FirstDate.SecondsFrom1970 then
		        DisplayEvents.Add E
		        
		        If E.Recurrence <> Nil then
		          RecurE = CheckRecurringEvents(E, FirstDate, EndDate)
		          If RecurE = Nil then Continue
		          For j = 0 to RecurE.LastIndex
		            DisplayEvents.Add RecurE(j)
		          Next
		        End If
		        
		      Elseif E.Recurrence <> Nil and E.StartDate.SecondsFrom1970 <= EndDate.SecondsFrom1970 then
		        RecurE = CheckRecurringEvents(E, FirstDate, EndDate)
		        If RecurE = Nil then Continue
		        For j = 0 to RecurE.LastIndex
		          DisplayEvents.Add RecurE(j)
		        Next
		      End If
		    Next
		  End If
		  
		  
		  u = DisplayEvents.LastIndex
		  
		  
		  
		  
		  If DisplayEvents.LastIndex > 1 then
		    
		    CombSort(DisplayEvents)
		    
		  elseif DisplayEvents.LastIndex = 1 then
		    //Insertion Sort
		    Dim temp As CalendarEvent
		    
		    temp = DisplayEvents(0)
		    If temp > DisplayEvents(1) then
		      DisplayEvents.Add temp
		      DisplayEvents.RemoveAt(0)
		    End If
		  End If
		  
		  If OnePerDay then
		    For i = u downto 1
		      If DisplayEvents(i).EndSeconds < DisplayEvents(i-1).EndSeconds then
		        DisplayEvents.RemoveAt(i)
		      elseif DisplayEvents(i).StartSeconds = DisplayEvents(i-1).StartSeconds then
		        DisplayEvents.RemoveAt(i)
		      End If
		    Next
		  End If
		  
		  
		  
		  #if DebugBuild
		    ms = (System.Microseconds - ms) / 1000
		    DrawInfo = str(ms)
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function String2Color(str As String) As Color
		  If str.Left(2) = "&c" then
		    str = str.Middle(3)
		  End If
		  
		  If str.Left(1) = "#" then
		    str = str.Middle(2)
		  End If
		  
		  Dim v As Variant = "&h" + str
		  
		  Return v.ColorValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1021
		Private Sub TimerAction(t As Timer)
		  
		  If t is Nil then Return
		  
		  'Dim D As New Date
		  Dim D As DateTime = DateTime.Now
		  
		  If HideScrollbar then
		    ShowScrollBar = False
		    HideScrollbar = False
		  End If
		  
		  If t.Period < 5000 then
		    t.Period = 5000
		    #if TargetDesktop
		      FullRefresh = True
		      Refresh(False)
		    #elseif TargetWeb
		      Redisplay()
		    #endif
		    
		    Return
		  End If
		  
		  If mViewType = TypeMonth then
		    If Today.Day <> D.Day then
		      'Today = New Date
		      Today = DateTime.Now
		      'MethodProfiler.LogMsg("RefreshTimer")
		      #if TargetDesktop
		        Refresh(False)
		      #elseif TargetWeb
		        Redisplay()
		      #endif
		    End If
		  elseif mViewType > TypeMonth then
		    If Today.Minute <> D.Minute then
		      'Today = New Date
		      Today = DateTime.Now
		      #if TargetDesktop
		        Refresh(False)
		      #elseif TargetWeb
		        Redisplay()
		      #endif
		    End If
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function VDate2SQLDate(VDate As String) As DateTime
		  
		  
		  Dim D As DateTime
		  
		  If VDate.Right(1) = "Z" then
		    D = New DateTime(val(VDate.Left(4)), _
		    val(VDate.Middle(5, 2)), _
		    val(VDate.Middle(7, 2)), _
		    val(VDate.Middle(10, 2)), _
		    val(VDate.Middle(12, 2)), _
		    val(VDate.Middle(14, 2)), _
		    0, _
		    New Timezone(0))
		  Else
		    D = New DateTime(val(VDate.Left(4)), _
		    val(VDate.Middle(5, 2)), _
		    val(VDate.Middle(7, 2)), _
		    val(VDate.Middle(10, 2)), _
		    val(VDate.Middle(12, 2)), _
		    val(VDate.Middle(14, 2)), _
		    0, _
		    Timezone.Current)
		  End If
		  '
		  'Dim GMTOffset As Integer = D.GMTOffset
		  'If VDate.Right(1) = "Z" then
		  'D.GMTOffset = 0
		  'End If
		  '
		  'D.Hour = 0
		  'D.Minute = 0
		  'D.Second = 0
		  '
		  'D.Year = val(Left(VDate, 4))
		  'D.Month = val(Mid(VDate, 5, 2))
		  'D.Day = val(Mid(VDate, 7, 2))
		  '
		  'D.Hour = val(Mid(VDate, 10, 2))
		  'D.Minute = val(Mid(VDate, 12, 2))
		  'D.Second = val(Mid(VDate, 14, 2))
		  '
		  'D.GMTOffset = GMTOffset
		  
		  Return D
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ViewChanged()
		  Dim lastFirstDate, lastLastDate As DateTime
		  
		  If FirstDate <> Nil Then
		    lastFirstDate = New DateTime(FirstDate)
		  End If
		  If LastDate <> NIl Then
		    lastLastDate = New DateTime(LastDate)
		  End If
		  
		  mFirstDate = Nil
		  mLastDate = Nil
		  
		  If LastDate <> Nil and FirstDate <> Nil and (lastFirstDate.SecondsFrom1970 <> FirstDate.SecondsFrom1970 or lastLastDate.SecondsFrom1970 <> LastDate.SecondsFrom1970) then
		    
		    If ViewType = TypeYear then
		      Redim DayColor(366)
		    End If
		    
		    Redim DisplayEvents(-1)
		    MonthsPopup.Visible = False
		    MoreEventsDate = Nil
		    
		    EraseBuffers()
		    
		    RaiseEvent ViewChange(FirstDate, LastDate)
		    
		  End If
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event CalendarEventFilter(cEvent As CalendarEvent) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Close()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ConstructContextualMenu(base As DesktopMenuItem, x As Integer, y As Integer, cEvent As CalendarEvent) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event DateSelected(D As DateTime)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event DoubleClick(X As Integer, Y As Integer) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event DragEvent(cEvent As CalendarEvent)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event DropEvent(cEvent As CalendarEvent)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event EditEvent(cEvent As CalendarEvent) As CalendarEvent
	#tag EndHook

	#tag Hook, Flags = &h0
		Event EditOrDeleteRecurrentEvent(cEvent As CalendarEvent) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event EventClicked(cEvent As CalendarEvent)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event KeyDown(Key As String) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event MouseWheel(X As Integer, Y As Integer, DeltaX As Integer, DeltaY As Integer) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event NewEvent(StartDate As DateTime, EndDate As DateTime)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Opening()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ShowHelptag(Str As String, cEvent As CalendarEvent) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ShowMoreEvents(D As DateTime) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ViewChange(StartDate As DateTime, EndDate As DateTime)
	#tag EndHook


	#tag Note, Name = Class Constants
		===Style===
		The following class constants are to be used to specify the Style to use with SetStyle function.
		
		<table width="15;55">
		Class Constant->Description
		StyleDefault->The default style.
		StyleICal->Macintosh iCal style.
		StyleGoogle->Google Calendar style.
		StyleDark->A dark style (black, grey and green).
		StyleOutlook2010->Office Outlook 2010 style.
		StyleOutlook2013->Office Outlook 2013 (beta) style.
		</table>
		
		===ViewType===
		The following class constants are to be used with the ViewType property.
		
		<table width="15;55">
		Class Constant->Description
		TypePicker->Displays a DatePicker.
		TypeYear->Displays a whole year.
		TypeMonth->Displays a Month calendar.
		TypeWeek->Displays a full week.
		TypeDay->Displays one day.
		TypeOther->Use the ViewDays property to set the amount of days to display. If ViewDays=5 days from Monday to Friday are displayed.
		</table>
		
	#tag EndNote

	#tag Note, Name = Description
		Displays a Calendar in several formats (Year, Month, Week, Day, ...) that presents CalendarEvents.<br/>
		This custom control based on a Canvas is similar to iCal on Mac OS and Google Calendar.
	#tag EndNote

	#tag Note, Name = Events
		==CalendarEventFilter==
		newinversion 1.4.0
		Fires if FilterEvents is True.<br>
		Return True from this Event if the passed CalendarEvent must be displayed.<br>
		Filtering events can be done on the Name, the Tag, the Color and any other relevant Property of the CalendarEvent class.
		
		==DateSelected==
		A date has been selected with the mouse.
		
		==DragEvent==
		A CalendarEvent is being dragged.
		
		==EditEvent==
		A CalendarEvent has been double-clicked in order to edit it.
		Editing a CalendarEvent must be handled here. If Nil is returned the CalendarEvent is not changed.
		
		Deleting an event can be handled here by calling:
		<source>
		me.RemoveEvent(cEvent, True)
		Return Nil
		</source>
		
		==NewEvent==
		Adding a CalendarEvent by dragging the mouse must be handled here.
		
		Example:
		<source>
		me.AddEvent( New CalendarEvent("New meeting", StartDate, EndDate)
		</source>
		
		==Open==
		The window is about to open.
		
		==ShowHelptag==
		Enables displaying a custom ToolTip.<br/>
		If True is returned, the system ToolTip is completely bypassed.
		
		==ViewChange==
		The current view has changed.
		StartDate and EndDate represent the date range that is currently displayed.
		Use me.ViewType to retrieve the current view (Picker, Year, Month, Week, Day ...)
		
		==ConstructContextualMenu==
		newinversion 1.1.1
		This event is called when it is appropriate to display a contextual menu for the control.
		
		If you return True, the contextual menu is displayed. The parameters ''x'' and ''y'' are the mouse locations.
		If the event was fired because of a non-mouse event, then x and y are both set to -1.
		If the mouse is over a CalendarEvent when this event is fired, ''cEvent'' hovered CalendarEvent.
	#tag EndNote

	#tag Note, Name = External Links
		Download page:
		http://www.jeremieleroy.com/products.php
	#tag EndNote

	#tag Note, Name = History
		===Version 1.7.4===
		*New:
		**When dragging an event stops DropEvent is called
		**Updated for Xojo 2016R4
		
		
		===Version 1.7.2 - Not Released===
		*Fix:
		**EventClicked event now fires properly when an event wasn't dragged
		**+X popup in MonthView now displays several columns of events
		
		===Version 1.7.0 - Released 2014-09-01 (Web), 2015-01-29 (Desktop) ===
		*New:
		**Compatible with WebApps
		**MonthView: Clicking on the +#, displays a popup with all events of the Day
		*Fix:
		**Better Retina graphics on MacOS compatible devices
		**Event Title is now displayed on events lasting more than a week
		**Repeat Relative monthly is now calculated, exported and imported correctly
		**Crash when dragging an event ouf the CalendarView
		**All events now display correctly when dragging an event in MonthView
		
		===Version 1.6.2 - Not Released ===
		*New:
		*Fix:
		**DrawEventWeek could crash with negative event width.
		**DatePicker reacting to MouseDown instead of MouseUp
		
		===Version 1.6.1 - 2014-06-08 ===
		*New:
		**Improved performance for large amount of CalendarEvents.
		**RemoveEventByID function.
		*Fix:
		**Day name display in Month view was shifted by one day.
		
		===Version 1.6.0 - Released 2014-03-21 ===
		*New:
		**Compatible with Retina displays, the text now looks perfect
		**Recurrent events
		**Date Picker
		**Improved CalendarEvent edit window
		
		
		===Version 1.5.0 - Released 2014-11-10 ===
		*New:
		**Changed the DoubleClick event. Return True if you handled the double-click.
		**Improved Reading of ICS (iCal) data
		
		===Version 1.4.1 - Released 2013-06-01 ===
		*New:
		**DayGradient property
		**When creating a new CalendarEvent, a "Cancel" button appears to cancel the creation of the CalendarEvent.
		
		
		===Version 1.4.0 - Released 2013-05-30 ===
		*New:
		**Search function
		**FocusOn function to go to the date of the passed Event.
		**FilterEvents property. If True, the CalendarEventFilter is fired for each event before displaying it.
		**CalendarEventFilter event. Return True if the event should be displayed.
		*Fix:
		**Events not displaying in Week view.
		**Events appearing twice in Week view.
		**Improved drawing performance.
		**Pressing a key used to scroll down. Now only the down arrow scrolls down.
		
		===Version 1.3.1 - Released 2012-11-24 ===
		*New:
		**PrintSimple and PrintAdvanced functions
		**Freeze property to prevent any refresh
		**YearMultipleEvents to display all event colors for each day
		*Fix:
		**WeekHeaderTextFormat doesn't display spaces in the day and MonthNames on Windows
		**Drawing error in MonthView for Sunday
		**Drawing error in MonthView for very long events
		
		===Version 1.2.2 - Released 2012-09-06 ===
		*New:
		**ShowHelptag event. Enables using custom HelpTags or disabling the ToolTip by returning True
		**CalendarEvent now has a Tag property
		*Fix:
		**ToolTip is now displayed in Week and Day view
		**Various demo window fixes
		
		===Version 1.2.1 - Released 2012-08-29 ===
		*New:
		**Double-click on day in Month view changes to week view
		**Scrollwheel / Trackpad can be disabled horizontally
		**TextFont property to change the font of all text in the CalendarView
		**Several FontSize properties in the Style structure.
		*Fix:
		**Events not displaying in 1 day view
		
		===Version 1.2 - Released 2012-08-21 ===
		*New:
		**Adapted display for Retina Macs (not tested on actual Retina Mac)
		**Keyboard arrows to scroll
		**ConstructContextualMenu event has a parameter for the clicked CalendarEvent
		**Edit the CalendarEvent time directly from the EditEvent window
		**Each CalendarEvent has an [[CalendarEvent.Editable|Editable]] property
		**HelpTagFormat property
		**DayEvent display height in Week view can be dragged ([[DayEventsHeight]])
		**StyleOutlook2013 constant
		**Style updates
		**Time format in week view can be edited
		
		*Fix
		**Fixed RemoveEvent bug that deleted the first event with the same date and length
		**Time bar not refreshing properly
		**Simultaneous events do not overlap in Week view (limited to 10 simultaneous events)
		
		===Version 1.1 - Released 2012-05-02===
		*New:
		**TypePicker constant
		**SelStart, SelEnd to set the selected dates in the CalendarPicker
		**DayStartHour, DayEndHour
		**ForceAM_PM
		**Style Property
		**StyleOutlook2010 constant
		**WeekHeaderTextFormat
		**Animate
		
		*Fix:
		**Several graphic enhancements
		**Colors in StyleDark
		**Day names on Mac OS
		
		
		===Version 1.0.3 - Released 2012-04-11===
		*New:
		**StyleDefault, StyleICal, StyleGoogle, StyleDark class constants
		**ImportFromDB function
		**ExportToDB function
		**RemoveEvent now has a RemoveFromDB property.
		
		*Fix:
		**CalendarView not updating after AddEvent
		
		
		
		===Version 1.0.2 - Released 2012-04-03===
		*New:
		**StyleDark
		**DisableDrag is replaced with DragEvents and CreateWithDrag
		
		*Fix:
		**Day background color not filling the box in TypeMonth
		**Time background color not displaying in TypeWeek
		**Resizing event to make a 15 minute event in TypeWeek
		**TypeYear not displaying non**day events
		**OutOfBoundsException in DrawTime on Mac OS
		**Drawing long event in TypeMonth that finishes on last day of week
		
		
		
		===Version 1.0.1 - Released 2012-04-02===
		*New:
		**DisplayWeeknumber As Boolean
		**MyColors.WeekNumber
		**MyColors.WeekNumberBackground
		**Day name is displayed inside the month grid for iCal style.
		**Drag events in Month and Week view to change start date/time
		**Resize event in TypeWeek
		**HeatMap in TypeYear
		**SetLength Function in CalendarEvent
		**VerticalGap and HorizontalGap properties for TypeYear
		**New Event "DragEvent". Fires when a CalendarEvent is dragged or resized
		
		*Fix:
		**Selected background color in month view if MyStyle.MDayNumberAlign=1
		**Day events in TypeWeek not aligned properly
		
		
		
		
		===Version 1.0.0 - Released 2012-03-30===
		First release
	#tag EndNote

	#tag Note, Name = See Also
		 Class.
		[[CalendarEvent]]
	#tag EndNote

	#tag Note, Name = ToDo list
		#Ignore in LR
		
		Month view
		-Setting for Month title position in Month view
		-Select element and delete it with Backspace or Delete ??
		
		Week view
		-limit amount of day events
		-Force AM/PM
		-DayStart time
		-DayEnd time
		-> NightColor
		-minHourHeight <-> DisplayXXHours
		
		Year view
		-Double click on month to display it in month view
		-Color days with amount of events per day (Yellow to red)
		-Event for date click 
		
		CalendarEvent
		Set Text color
		
		
		From MC8sens:
		-drag an event, then tap arrow on keyboard, the event disappears until you move the mouse.
		-Modify dates with a date picker in the EditEvent window.
		-Delete button becomes "Cancel" when creating an event.
		
		
	#tag EndNote


	#tag ComputedProperty, Flags = &h0
		#tag Note
			If True, in ViewType Month and Picker, the CalendarView will automatically calculate how many weeks are needed to display the whole month.
			If False, 6 weeks will always be displayed.
		#tag EndNote
		#tag Getter
			Get
			  return mAdaptWeeksPerMonth
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mAdaptWeeksPerMonth = value
			  
			  ViewChanged
			  
			  Redisplay()
			End Set
		#tag EndSetter
		AdaptWeeksPerMonth As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		#tag Note
			newinversion 1.1.0
			If True there is a smooth animation when using the Scroll function.
		#tag EndNote
		Animate As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected AnimationInProgress As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			If true a Border is displayed around the CalendarView.
			The default value is False.
		#tag EndNote
		Border As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		#tag Note
			Picture on which is drawn all graphics
		#tag EndNote
		Protected Buffer As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			If True, the Weekend will be colored with MyColors.Weekend color.
		#tag EndNote
		ColorWeekend As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			If True, the user can create a CalendarEvent by dragging the mouse.
		#tag EndNote
		CreateWithDrag As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		#tag Note
			Color for each day used in ViewType = TypeYear only.
		#tag EndNote
		Protected DayColor() As CalendarYearColors
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			newinversion 1.1.0
			If this property is different than 0.0, the remaining hours from DayEndHour to midnight will be darkened.
			The default value is 18.0
			
			==Example==
			This example sets the DayEndHour to 18:45.
			<source>
			me.DayEndHour=18.75
			</source>
		#tag EndNote
		DayEndHour As Single
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected DayEventClicked As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			newinversion 1.2.0
			If the value is -1 the height is automatically calculated depending on the amount of day events.
		#tag EndNote
		Private DayEventsHeight As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The names of each day of Week, starting by Sunday.
			DayNames(1) = Sunday
			DayNames(7) = Saturday
		#tag EndNote
		Shared DayNames(7) As String
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			newinversion 1.1.0
			If this property is different than 0.0, the hours from midnight to DayStartHour will be darkened.
			The default value is 6.0
			
			==Example==
			This example sets the DayStartHour to 8 AM.
			<source>
			me.DayStartHour=8.0
			</source>
		#tag EndNote
		DayStartHour As Single
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected DeletedIDs() As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mDIDay = Nil Then
			    mDIDay = New DateInterval(0,0,1)
			  End If
			  Return mDIDay
			End Get
		#tag EndGetter
		DIDay As DateInterval
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if mDIHour = Nil Then
			    mDIHour = New DateInterval(0,0,0,1)
			  end if
			  Return mDIHour
			End Get
		#tag EndGetter
		DIHour As DateInterval
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  
			  If mDIMonth = Nil Then
			    mDIMonth = New DateInterval(0,1,0)
			  End If
			  
			  Return mDIMonth
			End Get
		#tag EndGetter
		DIMonth As DateInterval
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		#tag Note
			newinversion 1.2.1
			If True, scrolling with the mousewheel or trackpad is disabled for changing the current display date.
			
			However, scrolling the hours in Week/Day view will never be disabled.
		#tag EndNote
		DisableScroll As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			The currently displayed Date.
			Change the DisplayDate to change the current view.
			
			==Notes==
			If you assign a date using
			<source lang="realbasic">
			me.DisplayDate = aDate
			</source>
			There is no need to refresh the CalendarView to show the selected date.
			
			However if you alter DisplayDate without assigning it a value, the CalendarView needs to be refreshed:
			<source lang="realbasic">
			//Change the month to December
			me.DisplayDate.Month = 12
			me.Redisplay() //This refreshes the CalendarView
			</source>
		#tag EndNote
		#tag Getter
			Get
			  return mDisplayDate
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  
			  If mDisplayDate <> Nil and value.SQLDate = mDisplayDate.SQLDate then
			    Return
			  End If
			  
			  If Value is Nil then
			    'Value = New Date
			    Value = DateTime.Now
			  End If
			  
			  mDisplayDate = New DateTime(value)
			  
			  ViewChanged
			  
			  Redisplay()
			End Set
		#tag EndSetter
		DisplayDate As DateTime
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected DisplayEvents() As CalendarEvent
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			If True, the week numbers are displayed in Month view, Week view and Day view.
		#tag EndNote
		DisplayWeeknumber As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  
			  If mDIWeek = Nil Then
			    mDIWeek = New DateInterval(0,0,7)
			  End If
			  Return mDIWeek
			End Get
		#tag EndGetter
		DIWeek As DateInterval
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  
			  If mDIYear = Nil Then
			    mDIYear = New DateInterval(1,0,0)
			  End If
			  Return mDIYear
			End Get
		#tag EndGetter
		DIYear As DateInterval
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private DragBack As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private DragEvent As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			#newinversion 1.7.1
			The Event was dragged
		#tag EndNote
		Private DragEventPerformed As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			If True, CalendarEvent items can be dragged with the mouse to alter the date or start time.
		#tag EndNote
		DragEvents As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected DragOffset As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected DragViewHeight As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private DrawInfo As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private DropObject As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Events() As CalendarEvent
	#tag EndProperty

	#tag Property, Flags = &h1
		#tag Note
			Set to True when all events are sorted.
			Set to false after loading events, creating an event, dragging an event.
		#tag EndNote
		Protected EventsSorted As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.4.0
			
			If True, before refreshing the display, the CalendarView fires the CalendarEventFilter Event
		#tag EndNote
		FilterEvents As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			The first date displayed in the CalendarView.
		#tag EndNote
		#tag Getter
			Get
			  
			  If mFirstDate is Nil then
			    
			    If DisplayDate is Nil then Return Nil
			    
			    If ViewType = TypeYear then
			      mFirstDate = New DateTime(DisplayDate.Year,1,1)
			      'mFirstDate.Day = 1
			      'mFirstDate.Month = 1
			      'mFirstDate.Hour = 0
			      'mFirstDate.Minute = 0
			      'mFirstDate.Second = 0
			      
			    ElseIf ViewType = TypeMonth or ViewType = TypePicker then
			      'mFirstDate = New Date
			      mFirstDate = New DateTime(DisplayDate.Year, DisplayDate.Month, 1, 0, 0, 0)
			      'If ViewType = TypeMonth then
			      'mFirstDate.SecondsFrom1970 = DisplayDate.SecondsFrom1970
			      'else
			      'mFirstDate.SecondsFrom1970 = DisplayDate.SecondsFrom1970
			      'End If
			      'mFirstDate.Day = 1
			      'mFirstDate.Hour = 0
			      'mFirstDate.Minute = 0
			      'mFirstDate.Second = 0
			      If AdaptWeeksPerMonth then
			        
			        If mFirstDate.DayOfWeek - FirstDayOfWeek < 0 then
			          'mFirstDate.Day = mFirstDate.Day - (mFirstDate.DayOfWeek - FirstDayOfWeek) - 7
			          mFirstDate = mFirstDate - New DateInterval(0,0,(mFirstDate.DayOfWeek - FirstDayOfWeek) + 7)
			        else
			          'mFirstDate.Day = mFirstDate.Day - (mFirstDate.DayOfWeek - FirstDayOfWeek)
			          mFirstDate = mFirstDate - New DateInterval(0,0,(mFirstDate.DayOfWeek - FirstDayOfWeek))
			        End If
			        
			      else
			        
			        WeeksPerMonth = 6
			        
			        If mFirstDate.DayOfWeek - FirstDayOfWeek <= 0 then
			          'mFirstDate.Day = mFirstDate.Day - (mFirstDate.DayOfWeek - FirstDayOfWeek) - 7
			          mFirstDate = mFirstDate - New DateInterval(0,0,(mFirstDate.DayOfWeek - FirstDayOfWeek) + 7)
			        else
			          'mFirstDate.Day = mFirstDate.Day - (mFirstDate.DayOfWeek - FirstDayOfWeek)
			          mFirstDate = mFirstDate - New DateInterval(0,0,(mFirstDate.DayOfWeek - FirstDayOfWeek))
			        End If
			      End If
			      
			    else
			      
			      'mFirstDate = New Date
			      'mFirstDate.SecondsFrom1970 = DisplayDate.SecondsFrom1970
			      mFirstDate = New DateTime(DisplayDate)
			      
			      If ViewType = TypeWeek then
			        ViewDays = 7
			        
			        If mFirstDate.DayOfWeek - FirstDayOfWeek < 0 then
			          'mFirstDate.Day = mFirstDate.Day - (mFirstDate.DayOfWeek - FirstDayOfWeek) - 7
			          mFirstDate = mFirstDate - New DateInterval(0,0,(mFirstDate.DayOfWeek - FirstDayOfWeek) + 7)
			        else
			          'mFirstDate.Day = mFirstDate.Day - (mFirstDate.DayOfWeek - FirstDayOfWeek)
			          mFirstDate = mFirstDate - New DateInterval(0,0,(mFirstDate.DayOfWeek - FirstDayOfWeek))
			        End If
			        
			      elseif ViewType = TypeDay then
			        //nothing
			      elseif ViewType = TypeOther then
			        If ViewDays = 5 then
			          'mFirstDate.Day = mFirstDate.Day - mFirstDate.DayOfWeek+2
			          mFirstDate = mFirstDate - New DateInterval(0,0,mFirstDate.DayOfWeek-2)
			        elseIf ViewDays > 2 then
			          'mFirstDate.Day = mFirstDate.Day - 1
			          mFirstDate = mFirstDate - New DateInterval(0,0,1)
			        End If
			      End If
			      
			      'mFirstDate.Hour = 0
			      'mFirstDate.Minute = 0
			      'mFirstDate.Second = 0
			      mFirstDate = mFirstDate - New DateInterval(0,0,0,mFirstDate.Hour,mFirstDate.Minute,mFirstDate.Second)
			    End If
			  End If
			  
			  return New DateTime(mFirstDate)
			End Get
		#tag EndGetter
		FirstDate As DateTime
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			The first day of week displayed in the CalendarView.
			1 = Sunday
			7 = Saturday
		#tag EndNote
		#tag Getter
			Get
			  return mFirstDayOfWeek
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mFirstDayOfWeek = value
			  
			  ViewChanged
			  
			  Redisplay()
			End Set
		#tag EndSetter
		FirstDayOfWeek As Byte
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		#tag Note
			newinversion 1.1.0
			If True, Hours in Week view and Day view will always be displayed with AM and PM.
			If False, the CalendarView tries to get the system default's hour format.
		#tag EndNote
		ForceAM_PM As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			
			snt the CalendarView from refreshing the display.
		#tag EndNote
		Freeze As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected FullRefresh As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected HeaderHeight As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			newinversion 1.2.0
			Use this property to edit the format of the ToolTip.
			
			<table width="15;55">
			Variable->Description
			%Start->StartDate
			%End->EndDate
			%Length->Event duration
			%Title->Event title
			%Location->Event location
			%Description->Event description
			</table>
			
			
			Default format is:
			%Start - %End<br/>
			%Title - %Location
		#tag EndNote
		HelpTagFormat As String
	#tag EndProperty

	#tag Property, Flags = &h1
		#tag Note
			#newinversion: 1.5.0
			
			If True, all hours between DayEndHour and DayStartHour won't be displayed.<br>
			This enables optimizing the view for the Day time / open hours.
		#tag EndNote
		Protected HideNightTime As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected HideScrollbar As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.4
			If True, the picLockedEvents picture is displayed all non editable CalendarEvent.
		#tag EndNote
		HighlightLockedEvents As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected HourHeight As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected lastAutoScroll As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			The last date displayed in the CalendarView.
		#tag EndNote
		#tag Getter
			Get
			  If mLastDate is Nil then
			    
			    If DisplayDate is Nil then Return Nil
			    
			    If ViewType = TypeYear then
			      mLastDate = New DateTime(DisplayDate.Year,12,31,23,59,59)
			      'mLastDate.Month = 12
			      'mLastDate.Day = 31
			      'mLastDate.Hour = 0
			      'mLastDate.Minute = 0
			      'mLastDate.Second = 0
			      'mLastDate.Day = mLastDate.Day + 1
			      'mLastDate.Second = mLastDate.Second - 1
			      
			    elseIf ViewType = TypeMonth or ViewType = TypePicker then
			      
			      If AdaptWeeksPerMonth then
			        'If ViewType = TypeMonth then
			        'mLastDate = New DateTime(DisplayDate)
			        'else
			        'mLastDate = New DateTime(DisplayDate)
			        'End If
			        'mLastDate.Day = 1                       //2022-02-10 -> 2022-02-01
			        'mLastDate.Month = mLastDate.Month + 1   //2022-03-01
			        'mLastDate.Day = mLastDate.Day - 1       //2022-02-28
			        'mLastDate.Hour = 0
			        'mLastDate.Minute = 0
			        'mLastDate.Second = 0
			        
			        mLastDate = DisplayDate - New DateInterval(0,0,DisplayDate.day-1) + New DateInterval(0, 1, 1)
			        mLastDate = mLastDate - DIDay
			        
			        WeeksPerMonth = Ceiling((mLastDate.SecondsFrom1970 - FirstDate.SecondsFrom1970 + 86400) / 604800)
			        
			        'mLastDate.SecondsFrom1970 = FirstDate.SecondsFrom1970
			        mLastDate = New DateTime(FirstDate)
			        'mLastDate.Day = mLastDate.Day + WeeksPerMonth * 7
			        mLastDate = mLastDate + New DateInterval(0,0,WeeksPerMonth * 7)
			      else
			        WeeksPerMonth = 6
			        mLastDate = New DateTime( FirstDate)
			        'mLastDate.Day = mLastDate.Day + 42
			        mLastDate = mLastDate + New DateInterval(0,0,42)
			        
			      End If
			      'mLastDate.Second = mLastDate.Second - 1
			      mLastDate = mLastDate - New DateInterval(0,0,0,0,0,1)
			    else
			      mLastDate = New DateTime(FirstDate)
			      
			      If ViewType = TypeWeek then
			        'mLastDate.Day = mLastDate.Day + 6
			        mLastDate = mLastDate + New DateInterval(0,0,6)
			      elseif ViewType = TypeDay then
			        //nothing
			      elseif ViewType = TypeOther then
			        If ViewDays > 2 then
			          'mLastDate.Day = FirstDate.Day + ViewDays-1
			          mLastDate = mLastDate + New DateInterval(0,0,ViewDays-1)
			        else
			          'mLastDate.Day = mLastDate.Day + ViewDays-1
			          mLastDate = mLastDate + New DateInterval(0,0,ViewDays-1)
			        End If
			      End If
			      
			      'mLastDate.Hour = 0
			      'mLastDate.Minute = 0
			      'mLastDate.Second = 0
			      'mLastDate.Day = mLastDate.Day + 1
			      'mLastDate.Second = mLastDate.Second - 1
			      
			      mLastDate = mLastDate - New DateInterval(0,0,0,mLastDate.Hour,mLastDate.Minute,mLastDate.Second)
			      mLastDate = mLastDate + DIDay
			      mLastDate = mLastDate - New DateInterval(0,0,0,0,0,1)
			      
			    End If
			  End If
			  
			  
			  
			  
			  return New DateTime(mLastDate)
			End Get
		#tag EndGetter
		LastDate As DateTime
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected LastDayOver As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		#tag Note
			Used in TargetWeb to simulate long press.
		#tag EndNote
		Protected lastMouseDown As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected LastMouseOver As CalendarEvent
	#tag EndProperty

	#tag Property, Flags = &h1
		#tag Note
			The last result when searching.
			If SortEvents is called again, this goes back to Nil.
		#tag EndNote
		Protected LastSearchResult As CalendarEvent
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected lastSize As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected lastToday As DateTime
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected lastX As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected lastY As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			newinversion 1.2.0
			If True, in Week view, the Day event display's height is fixed.
			
			If false, the user can drag the day event Separator.
		#tag EndNote
		LockDayEventsHeight As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mAdaptWeeksPerMonth As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private MaxReccurenceID As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDIDay As DateInterval
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDIHour As DateInterval
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDIMonth As DateInterval
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDisplayDate As DateTime
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDisplayMonth As DateTime
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDIWeek As DateInterval
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDIYear As DateInterval
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFirstDate As DateTime
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFirstDayOfWeek As Byte
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHiDPI As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			The minimum horizontal Gap in pixels between months in Year view.
		#tag EndNote
		minHGap As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mminHourHeight
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mminHourHeight = value
			  EraseBuffers()
			  Redisplay
			End Set
		#tag EndSetter
		minHourHeight As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		#tag Note
			The minimum vertical Gap in pixels between months in Year view.
		#tag EndNote
		minVGap As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastDate As DateTime
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared mLimitDate As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			The minimum hour height in pixels for Week and Day view.
		#tag EndNote
		Private mminHourHeight As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Month names from MonthNames(1)=January to MonthNames(12)=December.
			
			On Windows, the MonthNames are automatically retrieved.
			On Macintosh and Linux, the CalendarView will try to retrieve the MonthNames using Date.ToString(DateTime.FormatStyles.Long, DateTime.FormatStyles.None).
		#tag EndNote
		MonthNames(12) As String
	#tag EndProperty

	#tag Property, Flags = &h1
		#tag Note
			If True, a MonthPopup is displayed for the MoreEventsDate.
		#tag EndNote
		Protected MonthsPopup As MonthPopup
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected MoreEventsDate As DateTime
	#tag EndProperty

	#tag Property, Flags = &h21
		Private MovingScrollBar As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared mRegistered As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mScrollPosition As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mStyle As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUseISOWeekNumber As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mViewType As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Set of Colors used in the CalendarView.
			By using SetStyle method, the colors are changed.
		#tag EndNote
		MyColors As Colors
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mYearHeatMap As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mYearMonthsAmount As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			If True, in ViewType = TypeYear, if the day has multiple event colors, all colors will be displayed for that day instead of only the first one.
			
			Note that if YearHeatMap is True, this option has no effect.
		#tag EndNote
		Private mYearMultipleEvents As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mYearPicker As CalendarYearPicker
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Set of Styles used in the CalendarView.
			By using SetStyle method, the style is changed.
		#tag EndNote
		MyStyle As Styles
	#tag EndProperty

	#tag Property, Flags = &h21
		Private oktobreak As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private oldBuffer As Picture
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared picAjaxLoader As Variant
	#tag EndProperty

	#tag Property, Flags = &h0
		Shared picCloseMonthPopup As Picture
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected PickerView As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.4
			This picture is displayed over all Day events if HighlightLockedEvents is True.<br/>
			A Masked picture that is tiled over non Editable events.
		#tag EndNote
		Shared picLockedEvents As Picture
	#tag EndProperty

	#tag Property, Flags = &h21
		Private RefreshTimer As Timer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ScrollBarHeight As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ScrollBarWidth As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			Vertical ScrollPosition used in Week and Day view.
		#tag EndNote
		#tag Getter
			Get
			  return mScrollPosition
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  
			  value = max(0, min(VisibleHours, value))
			  
			  
			  If value = mScrollPosition then Return
			  
			  mScrollPosition = value
			  
			  Redisplay
			End Set
		#tag EndSetter
		ScrollPosition As Double
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		#tag Note
			newinversion 1.1.0
			Selection end date.
		#tag EndNote
		SelEnd As DateTime
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			newinversion 1.1.0
			Selection start Date.
		#tag EndNote
		SelStart As DateTime
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected ShowScrollBar As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mStyle
			End Get
		#tag EndGetter
		StyleType As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		#tag Note
			newinversion 1.2.1
			The text font to use for all texts in the CalendarView.
		#tag EndNote
		TextFont As String
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected TimeWidth As Byte
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected Today As DateTime
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			#newinversion 1.4.1
			
			If True, the background of the CalendarView is transparent. The background area depends on the current View (Year, Month, Week, Picker...)
		#tag EndNote
		TransparentBackground As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 496620547275652C2075736573207468652049534F207765656B206E756D626572206E6F726D
		#tag Getter
			Get
			  https://en.wikipedia.org/wiki/ISO_week_date
			  
			  Return mUseISOWeekNumber
			  
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mUseISOWeekNumber = value
			  
			  Redisplay
			End Set
		#tag EndSetter
		UseISOWeekNumber As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		#tag Note
			Amount of days to display for ViewType = TypeOther.
		#tag EndNote
		ViewDays As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected ViewHeight As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			Use this property to get or set the type of view currently displayed:
			Picker, Year, Month, Week, Day...
		#tag EndNote
		#tag Getter
			Get
			  return mViewType
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mViewType = value
			  
			  If value = TypeWeek then
			    ViewDays = 7
			  elseif value = TypeDay then
			    ViewDays = 1
			  End If
			  
			  ViewChanged
			  
			  Redisplay
			End Set
		#tag EndSetter
		ViewType As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If HideNightTime = False then
			    Return 24
			    
			  else
			    Return DayEndHour-DayStartHour + 2
			  End If
			End Get
		#tag EndGetter
		VisibleHours As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		#tag Note
			newinversion 1.1.0
			Date format to display over each day in Week and Day view.
			
			This string property takes the same format parameters as the PHP Date function:
			http://php.net/manual/en/function.date.php
			
			If a character needs to be escaped, a backslash "\" can be used.
			
			==Examples==
			
			<source>
			//Tuesday 08, February
			me.WeekHeaderTextFormat = "l d, F"
			
			//Feb. 8
			me.WeekHeaderTextFormat = "M. j"
			</source>
		#tag EndNote
		WeekHeaderTextFormat As String
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected WeeksPerMonth As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			If True, the Year view will display a "heat map" from yellow to red depending on how many [[CalendarEvent|CalendarEvents]] are on each day.
		#tag EndNote
		#tag Getter
			Get
			  return mYearHeatMap
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mYearHeatMap = value
			  
			  Redim DisplayEvents(-1)
			  Redisplay
			End Set
		#tag EndSetter
		YearHeatMap As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Note
			//#newinversion 1.6.1
			Sets the amount of Months to display in YearView.
			
			Minimum is 1, maximum is 12.<br/>
			Default is 12.
		#tag EndNote
		#tag Getter
			Get
			  If mYearMonthsAmount <=0 then
			    mYearMonthsAmount = 12
			  End If
			  
			  return mYearMonthsAmount
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  
			  If value <= 0 then
			    mYearMonthsAmount = 12
			  else
			    mYearMonthsAmount = value
			  End If
			  
			  ViewChanged
			  
			  Redisplay()
			End Set
		#tag EndSetter
		YearMonthsAmount As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mYearMultipleEvents
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mYearMultipleEvents = value
			  
			  Redim DisplayEvents(-1)
			  Redisplay
			End Set
		#tag EndSetter
		YearMultipleEvents As Boolean
	#tag EndComputedProperty


	#tag Constant, Name = AlignCenter, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = AlignLeft, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = AlignRight, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = DragMove, Type = Double, Dynamic = False, Default = \"2", Scope = Private
	#tag EndConstant

	#tag Constant, Name = DragResize, Type = Double, Dynamic = False, Default = \"3", Scope = Private
	#tag EndConstant

	#tag Constant, Name = DragView, Type = Double, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = FillGradientHorizontal, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FillGradientVertical, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FillOutlook2013, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FillSolid, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = JavascriptNamespace, Type = String, Dynamic = False, Default = \"jly.WebCalendarView", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kpicAjaxLoader, Type = String, Dynamic = False, Default = \"iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAEJGlDQ1BJQ0MgUHJvZmlsZQAAOBGFVd9v21QUPolvUqQWPyBYR4eKxa9VU1u5GxqtxgZJk6XtShal6dgqJOQ6N4mpGwfb6baqT3uBNwb8AUDZAw9IPCENBmJ72fbAtElThyqqSUh76MQPISbtBVXhu3ZiJ1PEXPX6yznfOec7517bRD1fabWaGVWIlquunc8klZOnFpSeTYrSs9RLA9Sr6U4tkcvNEi7BFffO6+EdigjL7ZHu/k72I796i9zRiSJPwG4VHX0Z+AxRzNRrtksUvwf7+Gm3BtzzHPDTNgQCqwKXfZwSeNHHJz1OIT8JjtAq6xWtCLwGPLzYZi+3YV8DGMiT4VVuG7oiZpGzrZJhcs/hL49xtzH/Dy6bdfTsXYNY+5yluWO4D4neK/ZUvok/17X0HPBLsF+vuUlhfwX4j/rSfAJ4H1H0qZJ9dN7nR19frRTeBt4Fe9FwpwtN+2p1MXscGLHR9SXrmMgjONd1ZxKzpBeA71b4tNhj6JGoyFNp4GHgwUp9qplfmnFW5oTdy7NamcwCI49kv6fN5IAHgD+0rbyoBc3SOjczohbyS1drbq6pQdqumllRC/0ymTtej8gpbbuVwpQfyw66dqEZyxZKxtHpJn+tZnpnEdrYBbueF9qQn93S7HQGGHnYP7w6L+YGHNtd1FJitqPAR+hERCNOFi1i1alKO6RQnjKUxL1GNjwlMsiEhcPLYTEiT9ISbN15OY/jx4SMshe9LaJRpTvHr3C/ybFYP1PZAfwfYrPsMBtnE6SwN9ib7AhLwTrBDgUKcm06FSrTfSj187xPdVQWOk5Q8vxAfSiIUc7Z7xr6zY/+hpqwSyv0I0/QMTRb7RMgBxNodTfSPqdraz/sDjzKBrv4zu2+a2t0/HHzjd2Lbcc2sG7GtsL42K+xLfxtUgI7YHqKlqHK8HbCCXgjHT1cAdMlDetv4FnQ2lLasaOl6vmB0CMmwT/IPszSueHQqv6i/qluqF+oF9TfO2qEGTumJH0qfSv9KH0nfS/9TIp0Wboi/SRdlb6RLgU5u++9nyXYe69fYRPdil1o1WufNSdTTsp75BfllPy8/LI8G7AUuV8ek6fkvfDsCfbNDP0dvRh0CrNqTbV7LfEEGDQPJQadBtfGVMWEq3QWWdufk6ZSNsjG2PQjp3ZcnOWWing6noonSInvi0/Ex+IzAreevPhe+CawpgP1/pMTMDo64G0sTCXIM+KdOnFWRfQKdJvQzV1+Bt8OokmrdtY2yhVX2a+qrykJfMq4Ml3VR4cVzTQVz+UoNne4vcKLoyS+gyKO6EHe+75Fdt0Mbe5bRIf/wjvrVmhbqBN97RD1vxrahvBOfOYzoosH9bq94uejSOQGkVM6sN/7HelL4t10t9F4gPdVzydEOx83Gv+uNxo7XyL/FtFl8z9ZAHF4bBsrEwAAAAlwSFlzAAALEwAACxMBAJqcGAAAAvtJREFUWAmtVq0PcVEYP97ZNIEgSKYQzBRBNpuq8V8ooiDZBEUVFJpqM3+BwEygmAmCQNBsNq/f2fucPY5z7rl4z3bvee7z/XnuEeLL1W63H8Fg8IH9SxW/icViMekAdpOm5XL52O12Rhrn/8M/dHg0Gj3q9bpRyfl8luy0c9npdPrYbrdiPp9ztBEOGrFPJLwvFAqSXCwWH7PZLGDj5XjIkeFQKMRJRtiagWQyqQyu12uBbBg1aMjVaqUwiURCwTbA6gAEarWakmu1Wgq2Aaj77XaTZESfy+VUEDYZTwe63W4gEolI2cvlImz9QMpRd1rZbJZAz93TAUg2m02lYDgcyt5QCAYgevqMRqOClxB40FFGPHw6pANAptNp+ehzXa1WA5lMhnSLXq8n4fv9HqAHCKQ7n89LWqlUUqmHsfF4LKdCEp+v6/VKoJAOHA4HhRgMBgJdz5uu0WhI+rMEAmVRzBqAqOEwoTGOmAjqC+CRHd4bihlGj8cjyco9Ho+LTqfzIvDC4PHBAwAbmhJ9oZdGOQAmCPX7faE7stlsXvjA61qoOTVlKpX6LAj0AfWEHonLMKfzxuR4XzCaxzV2vhQ5mD5OrUPfG9mWQeqJIDp1sViI0+n0JgyEV9cbBXwiMRk4toOTycSnyP9lUxkol8vCKwO/muXnwq+6vpJ3TYKzCaGAn1yfeOHnLLA64EfY5Qz+AfwYprrz0/DNAcw/ulMXrFQqb7wuB0DHlOnXNvwP6If1otTEDK8/MU6Z481nCoqOZ3UfgCD3FIbxe+XGcahAmS1yMk6REx9SDj0wCr1Y4XBY7ioDUEyXSfJOcvx78ewQnZ9yFDHHIQBeb66PYHUr9mLkzkHQayrgHP0F+QWVDOq7KoFO4N9cEQx4LThHaUYjoyxe/E4HoIAmAoq9oidD/EJK2SCavjsd2O/3SoYrVkgDgHJi1Pws1QM2ZoredNO1yQCPOUf2qNttvE4H0Mm4xZpSj5LAQaq5bsQko/P89I3pwHHrdTa4DPwF1Xafbg9o8JUAAAAASUVORK5CYII\x3D", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kPicCloseMonthPopup, Type = String, Dynamic = False, Default = \"iVBORw0KGgoAAAANSUhEUgAAAAwAAAAMCAYAAABWdVznAAAEJGlDQ1BJQ0MgUHJvZmlsZQAAOBGFVd9v21QUPolvUqQWPyBYR4eKxa9VU1u5GxqtxgZJk6XtShal6dgqJOQ6N4mpGwfb6baqT3uBNwb8AUDZAw9IPCENBmJ72fbAtElThyqqSUh76MQPISbtBVXhu3ZiJ1PEXPX6yznfOec7517bRD1fabWaGVWIlquunc8klZOnFpSeTYrSs9RLA9Sr6U4tkcvNEi7BFffO6+EdigjL7ZHu/k72I796i9zRiSJPwG4VHX0Z+AxRzNRrtksUvwf7+Gm3BtzzHPDTNgQCqwKXfZwSeNHHJz1OIT8JjtAq6xWtCLwGPLzYZi+3YV8DGMiT4VVuG7oiZpGzrZJhcs/hL49xtzH/Dy6bdfTsXYNY+5yluWO4D4neK/ZUvok/17X0HPBLsF+vuUlhfwX4j/rSfAJ4H1H0qZJ9dN7nR19frRTeBt4Fe9FwpwtN+2p1MXscGLHR9SXrmMgjONd1ZxKzpBeA71b4tNhj6JGoyFNp4GHgwUp9qplfmnFW5oTdy7NamcwCI49kv6fN5IAHgD+0rbyoBc3SOjczohbyS1drbq6pQdqumllRC/0ymTtej8gpbbuVwpQfyw66dqEZyxZKxtHpJn+tZnpnEdrYBbueF9qQn93S7HQGGHnYP7w6L+YGHNtd1FJitqPAR+hERCNOFi1i1alKO6RQnjKUxL1GNjwlMsiEhcPLYTEiT9ISbN15OY/jx4SMshe9LaJRpTvHr3C/ybFYP1PZAfwfYrPsMBtnE6SwN9ib7AhLwTrBDgUKcm06FSrTfSj187xPdVQWOk5Q8vxAfSiIUc7Z7xr6zY/+hpqwSyv0I0/QMTRb7RMgBxNodTfSPqdraz/sDjzKBrv4zu2+a2t0/HHzjd2Lbcc2sG7GtsL42K+xLfxtUgI7YHqKlqHK8HbCCXgjHT1cAdMlDetv4FnQ2lLasaOl6vmB0CMmwT/IPszSueHQqv6i/qluqF+oF9TfO2qEGTumJH0qfSv9KH0nfS/9TIp0Wboi/SRdlb6RLgU5u++9nyXYe69fYRPdil1o1WufNSdTTsp75BfllPy8/LI8G7AUuV8ek6fkvfDsCfbNDP0dvRh0CrNqTbV7LfEEGDQPJQadBtfGVMWEq3QWWdufk6ZSNsjG2PQjp3ZcnOWWing6noonSInvi0/Ex+IzAreevPhe+CawpgP1/pMTMDo64G0sTCXIM+KdOnFWRfQKdJvQzV1+Bt8OokmrdtY2yhVX2a+qrykJfMq4Ml3VR4cVzTQVz+UoNne4vcKLoyS+gyKO6EHe+75Fdt0Mbe5bRIf/wjvrVmhbqBN97RD1vxrahvBOfOYzoosH9bq94uejSOQGkVM6sN/7HelL4t10t9F4gPdVzydEOx83Gv+uNxo7XyL/FtFl8z9ZAHF4bBsrEwAAAAlwSFlzAAALEwAACxMBAJqcGAAAAFZJREFUKBW9jlEOADAEQ223dgLH3tKPiiH72yRC6lEi38LMFjIbZn12ALXuwOAQtQOgq6pz3mCAyEsRxry8BPEWh0O+zsXo4gsRJtBp5SXCuB57ur2vGx8QJltMxO09AAAAAElFTkSuQmCC", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kPicLockedEvents, Type = String, Dynamic = False, Default = \"iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAEJGlDQ1BJQ0MgUHJvZmlsZQAAOBGFVd9v21QUPolvUqQWPyBYR4eKxa9VU1u5GxqtxgZJk6XtShal6dgqJOQ6N4mpGwfb6baqT3uBNwb8AUDZAw9IPCENBmJ72fbAtElThyqqSUh76MQPISbtBVXhu3ZiJ1PEXPX6yznfOec7517bRD1fabWaGVWIlquunc8klZOnFpSeTYrSs9RLA9Sr6U4tkcvNEi7BFffO6+EdigjL7ZHu/k72I796i9zRiSJPwG4VHX0Z+AxRzNRrtksUvwf7+Gm3BtzzHPDTNgQCqwKXfZwSeNHHJz1OIT8JjtAq6xWtCLwGPLzYZi+3YV8DGMiT4VVuG7oiZpGzrZJhcs/hL49xtzH/Dy6bdfTsXYNY+5yluWO4D4neK/ZUvok/17X0HPBLsF+vuUlhfwX4j/rSfAJ4H1H0qZJ9dN7nR19frRTeBt4Fe9FwpwtN+2p1MXscGLHR9SXrmMgjONd1ZxKzpBeA71b4tNhj6JGoyFNp4GHgwUp9qplfmnFW5oTdy7NamcwCI49kv6fN5IAHgD+0rbyoBc3SOjczohbyS1drbq6pQdqumllRC/0ymTtej8gpbbuVwpQfyw66dqEZyxZKxtHpJn+tZnpnEdrYBbueF9qQn93S7HQGGHnYP7w6L+YGHNtd1FJitqPAR+hERCNOFi1i1alKO6RQnjKUxL1GNjwlMsiEhcPLYTEiT9ISbN15OY/jx4SMshe9LaJRpTvHr3C/ybFYP1PZAfwfYrPsMBtnE6SwN9ib7AhLwTrBDgUKcm06FSrTfSj187xPdVQWOk5Q8vxAfSiIUc7Z7xr6zY/+hpqwSyv0I0/QMTRb7RMgBxNodTfSPqdraz/sDjzKBrv4zu2+a2t0/HHzjd2Lbcc2sG7GtsL42K+xLfxtUgI7YHqKlqHK8HbCCXgjHT1cAdMlDetv4FnQ2lLasaOl6vmB0CMmwT/IPszSueHQqv6i/qluqF+oF9TfO2qEGTumJH0qfSv9KH0nfS/9TIp0Wboi/SRdlb6RLgU5u++9nyXYe69fYRPdil1o1WufNSdTTsp75BfllPy8/LI8G7AUuV8ek6fkvfDsCfbNDP0dvRh0CrNqTbV7LfEEGDQPJQadBtfGVMWEq3QWWdufk6ZSNsjG2PQjp3ZcnOWWing6noonSInvi0/Ex+IzAreevPhe+CawpgP1/pMTMDo64G0sTCXIM+KdOnFWRfQKdJvQzV1+Bt8OokmrdtY2yhVX2a+qrykJfMq4Ml3VR4cVzTQVz+UoNne4vcKLoyS+gyKO6EHe+75Fdt0Mbe5bRIf/wjvrVmhbqBN97RD1vxrahvBOfOYzoosH9bq94uejSOQGkVM6sN/7HelL4t10t9F4gPdVzydEOx83Gv+uNxo7XyL/FtFl8z9ZAHF4bBsrEwAAAAlwSFlzAAALEwAACxMBAJqcGAAAAQ9JREFUOBGtk1kSgjAQRIkFF1Dhx+0Q3v8wLn8uF6BK7I4zqaAJTKrMT4rQPGZ6Om4YhmMlq+/7V9M0Z+fcQ89yO75bQn+AfhFran0ohK2h333DyPL0f8E8UGAXY5vZyrRTBy9awG56kNuhm4WxOJcDxOeArSDepzxTnXR6Gk1IX8Z7AYy2PScrLITdWUgWaPUMNrAyD8sCAWvhydbg2QhGYAg2H7ikMgsseaNGQxHPkjfg87uqkmkmYdQEDwVmiUYWRqBvWdq0VDZ7oxYFsGs8TVaTWjU8sVYWopEC8Yy21YZoTHqmcO30JzYqmJum6rgDFnKbBApsdgAC67Aztz4xoxxSEMEsnnXQb/BZiN8bgevxkKVkxysAAAAASUVORK5CYII\x3D", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kProductKey, Type = String, Dynamic = False, Default = \"CalendarView", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kReleaseDate, Type = Double, Dynamic = False, Default = \"20161124", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = String, Dynamic = False, Default = \"1.7.3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = LayoutEditorIcon, Type = String, Dynamic = False, Default = \"iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAACxIAAAsSAdLdfvwAAAgdSURBVGhD7VpraJNXGG6S5takSZqkaXpNr+m9TW9ba1u79WpnZYxdvezHxgTdyAZOxMEGgrIxp1Xnpd7qZc4bomze5g/xx8SJMib7MabCUBEmCE7cLKvScvY8p19KrGmSrkX9kcDDm++c9zvf897Oeb+mcUKIuCeHn/GsqcUTJE9HTS15rhczYGLpF4vAY2kYS6FYCk1yZ4qlUCyFJptCcdF/NNXV1edqampEMDC2AUuoMRYXCXtqiuPGYhVungxG6YdLBSipioqKyqdNmyb8fv8oFi5cKGpra++mpqbao0ulqTnIgg2O1gBNRUXFup6eHlFVVTWKuro60dHRIcrKyuYzCpGNeEoGmPGprKy83d3dLSAfAY0qLy//EQbonkkDmD6FhYWzW1paZO6DrPD5fNcRkWF+b25uFojEUF5eXil1wxvxFCIAUtqSkpKT9D5SheSF1+tdDXmeBhBdXV2iuLj4K+hqnikD6NGsrKxckB2ip2EICQ9brdZGeHwp64FjnZ2dorS09BYyzTQRA1CMqh1F2d07inP6dpbk/gJ5CfIvSuAC0NtfmO2jXvC7RNRFTI8WFBQsa21tpYclcH0O46lGo9EL8oPYnWRNNDQ0iNzc3FfCp9FICoGAut/reQfk/9zbUCGO9DSL43NmSJx692Upj73VJQ6/1CSw7QoY8dP2vIzcgCETMcCQn5//Bw0AcZlCmZmZS0DSAthB+ATqQ861t7cLROUYU278KIyQB5kV+5t84uTbM8X3r7aJAy01YldFgYD3SVbK3ZVecbC1ThyfPUMcfaNDIBrXN2ekOBUHjJ4d426jSvp04aCSxEGORAdNJlMhdxzAlJaWNp8pxLn6+nqBaDx0u92e8QygB7d6Utu/qS6SXidRGEMMYvx0X1ryF5vTXZ8Da7Zmp51T5gT1D75QK7blpC/HGpqoIgCC8R6P5wB3n5ycHEkS9XCKnueeT09rNJpMzN0LzDc2NlLns/GKGQ/WgtjZQ531JCOB68vrzAntmPMCHiATyAaKNrns/oDe/uYq6l7FuCEqA2w2mwvEBnhYgZRME5fLtYCep4cZIcCWnp5+kAZQp6mpiSn2O8b1oaKAB5u2ZLkfAiKADQ7bHIynAGaFnF6RFhq0JdN9nbpIId7zt6IXPoXoYbQHH6JNEIiCyMjIILF7Wq3WE5zj+J7gcDjeRC1IHRY0UyolJeXFUMVMAwAWYyXA3aUYcAG6EDuNCmNJSKcb2wuy6H2BGvgHY9aIEaAHYcAl9j7Ic5InqUMYT6JxAe8yzQA3dG9Rj+A9uN7LubFRwIPjFQ/aIInEUORZqBuTk6x9bufKfY0+WSeMAmoksgH0nN1ur2Za4MAicWkAUmo2PR5MSkkjq9Pp3MYIUJcHHQwZQLE7Hk+jx09ieh65XgfMBT4F+jelOC6B7ANusQSuBSJBGZUB8SDUx9xPTk6WwCH1AG3ECoz7gfeDgRT6aPr06ftpLHWxCwm0GQLjHwRHa8SYEQM22K2WjU7be/DyWUB6eFdZvvi2rlSwWI/MbBJ7ny+TXuc80ZfqpIxsAPLcjIffIQlEQpJiWrS1tckTNxRggOB2S32CPVNSUtJFbrfBUaC31ydZqkDkJglzNzr6Wrs8rJjj9DSME9C5ut5q3o0CX8RrApGhDG8AU8JiscyjN7HjMG3+F7Kzs2U9oLWoDi7mdSZjMjx/kycsc5ukQXbwa4v5COY+XqPXzVIKnMWd06uNr4YRYr0tUeA+yogG6BITE08zj2HIpMAIYi2+rcliZjp9nWjyo32QngZpAS/fB+nXQTYfSAeSg4rb2KvT5tP71FXk+AbQUwaDwYv0GeLWiSIUaNoEep71mKMnfRFQk5CQcJn3EeybEIHbOOzMigG6tQmGfeiBBLwtYIzA9R6FOLdXLaAObKeUMMCLCEl9GEsZ1gANDFjO3gZESJwYjo+PbwRxJw+tCHDr9fqVTDveS0lHYM15ym5lXGs0nMFeLiAFtkixxqDvVbbVR7rNQMOH+QVMM+pLg42GsAYYQOAaDyNIPpjygkI+Qp8vU0QPb9fA+8O8n+ChBnmaxQyY4NHD3FGQNoKRgFevIM9zQh1i0O3GVjqwp7ZE6jMKkAPjHWQq7D6zcABJz+l0OuavwNhSPNgcXIjjNWrQ0dBY3Hue5LkG2gyuM4Qo5vEMAVk/CxLkBIuTHSny+zauVwFzgU7AD5zhtskzgN6nPiU7VayxDNfP0WieyIGPFg85wH4HUgIkBlUqVfHYrTCMAeyNzIjCEtYA14ADZBOI78sxxyYsEwSu9GKOYH6zy2RXip5HFve23AxJnGcCdEn+fkB/Z2meYFuB63tKzYzwB1E3PPYvT1y1Wi0fDjnaeUZ+WR/5mYrGYq1C3D/IdQi8T1Bew5wRD7WsUqmaV6vVvwGCQJ5LUuz/eTYEagRzd6G7GPJLGhDQZ+rh+2hTx4eq8dDFgBgD2XkGRSnkV9xDB0hwLcCO7ydCrMc9njuNA/CC3CLgInADEAAJ/wp8B3wCHTZ7bK/zcN0P3Ff07kD+IJ2hMGJD5gD4ouJTwNRxAdpIBoSYT8BYFlCurFUJWQCweePLCBs6NnFpQAFQClQA5UARwG6Vc9Rn2lGX7wjUYxdLyWtGVH7oNT3A10SbgkRlTLp1gh8WsxGwjllPtsx8qCIZDe7/9CRbZEq+E5BY4EyQr6CKIcF61JFvZk/0o5Cf1N9Cx64R+30g2h0quJ2eyt+LYxGIRWCyv9BMzIOT/ceQqfnrdHANxWpgYhGc+gj8B5BZyrgaM9VCAAAAAElFTkSuQmCC", Scope = Public
	#tag EndConstant

	#tag Constant, Name = LineNone, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = LineThinDotted, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = LineThinDouble, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = LineThinSolid, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = NavigatorIcon, Type = String, Dynamic = False, Default = \"iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAACxIAAAsSAdLdfvwAAAGUSURBVDhPpZO9SwJhHMd/nNqd56l1F+dhmJf4EggiCA2BW+DY6uAUNPcPOPl/SIPla6m9DS2tLUFLuDQHES5Cg7g8fR+5Oyw4FTr48Hm+3+d+v5uOGGO0ks45MRdWD/MPLFtQKBRoFQ8Jk9z4NZzNZiu5XK7Nvbh06YJ8Pk82GB7hzCw7/b25S24QvjYnmUwewiyTyTS4rTy/u43tOAyNSHFg6AG7o3Q6PSeRSNRTqdQ4Ho8H4AnP9t21pnoHEb0xjBozwDjITZjINE0yDMOLwXEsFqvzDPd45j3PWHDa17cZfHalboXBCc9wiaLRKOm6XoEZXLTysZV5T3jRoRsKFXqb4Ro61guHyqRpGqmq+gizv1g9tQPyfkdRnrtBZQqPwB3ODH2ZZFmOBIPBmYIL0F7gnff8viVJNy2//6spihpMLUk8gBlcJlEUq5IkMbgEkw1yxeqrlz5fv7nh+4bL4Ag8ITO4Rh6PZwQ+AT87CIIgIU/AW0MQ9i4E4QUw8AFq4BVMaZ2ngZfcWGfedZgv/fff+AN7RypgaWc9OwAAAABJRU5ErkJggg\x3D\x3D", Scope = Public
	#tag EndConstant

	#tag Constant, Name = PickerDay, Type = Double, Dynamic = False, Default = \"0", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = PickerDecade, Type = Double, Dynamic = False, Default = \"4", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = PickerMonth, Type = Double, Dynamic = False, Default = \"1", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = PickerYear, Type = Double, Dynamic = False, Default = \"2", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = StyleDark, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = StyleDefault, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = StyleGoogle, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = StyleICal, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = StyleOutlook2010, Type = Double, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = StyleOutlook2013, Type = Double, Dynamic = False, Default = \"5", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeDay, Type = Double, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeMonth, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeOther, Type = Double, Dynamic = False, Default = \"5", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypePicker, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeWeek, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = TypeYear, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant


	#tag Structure, Name = Colors, Flags = &h1
		Border As Color
		  Line As Color
		  Title As Color
		  DayName As Color
		  DayNumberActive As Color
		  DayNumber As Color
		  DayNumberBackground As Color
		  Today As Color
		  WDefaultColor As Color
		  Selected As Color
		  Header As Color
		  Weekend As Color
		  WeekDay As Color
		  YBackground As Color
		  WeekNumber As Color
		  WeekNumberBackground As Color
		  TimeBackground As Color
		  Time As Color
		  OtherMonth As Color
		  PBackground As Color
		  PSelected As Color
		  POver As Color
		  PArrow As Color
		  PDayNumber As Color
		  PDayNumberActive As Color
		  Line2 As Color
		  PDayNumberToday As Color
		  MainColor As Color
		  MSelectedText As Color
		  WeekDay2 As Color
		PBackground2 As Color
	#tag EndStructure

	#tag Structure, Name = MonthPopup, Flags = &h1
		Visible As Boolean
		  SQLDate As String*10
		  Left As Integer
		  Top As Integer
		  Width As Integer
		  Height As Integer
		Yoffset As Integer
	#tag EndStructure

	#tag Structure, Name = Styles, Flags = &h1
		MBorderSolid As Boolean
		  MColorOffset1 As Byte
		  MColorOffset2 As Byte
		  MColorOtherMonth As Boolean
		  MDayNameAlign As Byte
		  MDayNumberAlign As Byte
		  MDayNumberBackground As Boolean
		  MDayRoundRect As Boolean
		  MDayTextBold As Boolean
		  MDayTextColor As Color
		  MDayTransparency As Color
		  MDayTransparent As Boolean
		  MEventFill As Byte
		  MEventHeight As Byte
		  MEventTextSize As Byte
		  MFirstDayOfMonthName As Boolean
		  MFirstDayOfMonthBold As Boolean
		  MHasSelectedTextColor As Boolean
		  MHourBold As Boolean
		  MLeftOffset As Byte
		  MNumberXOffset As Byte
		  MNumberYOffset As Byte
		  MTextBold As Boolean
		  MTextOffset As Byte
		  PDayNameBold As Boolean
		  PDayNamePos As Byte
		  PDayNumberBold As Boolean
		  PDayNumberPos As Byte
		  PTextSize As Byte
		  PLineHorizontal As Byte
		  PLineVertical As Byte
		  WAutoTextColor As Boolean
		  WBodyColorOffset1 As Byte
		  WBodyColorOffset2 As Byte
		  WBodyGradientVertical As Boolean
		  WBodyTextBold As Boolean
		  WBodyTextSize As Byte
		  WBodyTransparency As Color
		  WEventFill As Byte
		  WEventHeight As Byte
		  WHalfHourColorOffset As Byte
		  WHalfHourLineStyle As Byte
		  WHeaderColorOffset As Byte
		  WHeaderHeight As Byte
		  WHeaderTextBold As Boolean
		  WHeaderTextFormat As String * 30
		  WHeaderTextSize As Byte
		  WHeaderTransparency As Color
		  WHourLineStartX As Byte
		  WRoundRect As Boolean
		  WTextColor As Color
		  WTimeAlign As Byte
		  WTimeFormat As String*12
		  WTimeVOffset As Int8
		  WTodayHeader As Boolean
		  YLineHorizontal As Byte
		  YLineVertical As Byte
		  YTitleTextSize As Byte
		  YNumbersTextSize As Byte
		  MTitleTextSize As Byte
		  MNumbersTextSize As Byte
		  WTextSize As Byte
		FillGradient As Boolean
	#tag EndStructure


	#tag ViewBehavior
		#tag ViewProperty
			Name="AllowAutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Tooltip"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocusRing"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocus"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowTabs"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Transparent"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
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
			InitialValue=""
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
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Visible=false
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backdrop"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AdaptWeeksPerMonth"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Animate"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Border"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ColorWeekend"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CreateWithDrag"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DayStartHour"
			Visible=true
			Group="Behavior"
			InitialValue="8"
			Type="Single"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DayEndHour"
			Visible=true
			Group="Behavior"
			InitialValue="18"
			Type="Single"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DisplayWeeknumber"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DragEvents"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ForceAM_PM"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HelpTagFormat"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockDayEventsHeight"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="minHGap"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="minHourHeight"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="minVGap"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ScrollPosition"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ViewDays"
			Visible=true
			Group="Behavior"
			InitialValue="5"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ViewType"
			Visible=true
			Group="Behavior"
			InitialValue="2"
			Type="Integer"
			EditorType="Enum"
			#tag EnumValues
				"0 - Picker"
				"1 - Year"
				"2 - Month"
				"3 - Week"
				"4 - Day"
				"5 - Other"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="WeekHeaderTextFormat"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="YearHeatMap"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DisableScroll"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TextFont"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Freeze"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="YearMultipleEvents"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FilterEvents"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TransparentBackground"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="VisibleHours"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="YearMonthsAmount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StyleType"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HighlightLockedEvents"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FirstDayOfWeek"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Byte"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="UseISOWeekNumber"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
