#tag Class
Protected Class MethodProfiler
	#tag Method, Flags = &h0
		Sub Constructor(name as String)
		  // Call this constructor to log the entry and exit of a method.
		  // Pass "CurrentMethodName" as its first argument in order to
		  // have the name of the method logged.
		  // Pass false as the second argument in order to have it not log
		  // when the method is exited.
		  // Using this constructor will also indent any further msgs logged
		  // with the Log() method, making it easier to read.
		  
		  #if DebugBuild or Enabled
		    
		    if LogDepth < 0 then
		      // disabled
		      return
		    end if
		    
		    LogMsg "<"+name+"> Entered"
		    
		    gTimeSum.Append 0
		    mName = name
		    mTime = Microseconds
		    LogDepth = LogDepth + 1
		    
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Destructor()
		  #if DebugBuild or Enabled
		    
		    if LogDepth <= 0 then
		      // disabled
		      return
		    end if
		    
		    dim t as Double = Microseconds-mTime
		    
		    dim innerTimes as Double = gTimeSum.Pop // summed-up time from deeper level
		    
		    if gTimeSum.Ubound >= 0 then
		      gTimeSum.Append gTimeSum.Pop + t // sums up time for outer level
		    end if
		    
		    dim xtra as String
		    if innerTimes > 0 then
		      dim pc as integer = (t-innerTimes)/t*100
		      if pc > 10 then
		        xtra = " (missing "+Format((t-innerTimes)/1000,"#.000")+"ms, "+Format(pc,"#")+"%)"
		      end
		    end if
		    
		    LogDepth = LogDepth - 1
		    LogMsg "<"+mName+"> "+Format(t/1000,"#.000")+"ms"+xtra
		    
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub LogMsg(msg as String)
		  // Call this to write out a msg to the System Console, and optionally to a file
		  
		  #if DebugBuild or Enabled
		    
		    if LogDepth < 0 then
		      // logging disabled
		      return
		    end if
		    
		    ' prepare a string for indentation of the logged messages
		    static spc as String = " "
		    static tab as String = Chr(9)
		    if spc = " " then
		      for i as Integer = 1 to 5 ' that generates strings 32 chars wide
		        spc = spc + spc
		        tab = tab + tab
		      next
		    end
		    
		    ' write to the console
		    System.DebugLog spc.Left(LogDepth*2) + msg
		    
		    #if AlwaysWriteToFile or (not DebugBuild and Enabled)
		      ' write to a file (here: into the Desktop folder)
		      
		      ' first, prepare the FolderItem that specifies where the logfile goes
		      if gOutFile = nil then
		        gOutFile = OutputFileForLogging
		      end
		      
		      TextOutputStream.Append (gOutFile).WriteLine tab.Left(LogDepth) + msg
		    #endif
		    
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function OutputFileForLogging() As FolderItem
		  // Called once, when needed, to return the file where the logged msgs shall be written to
		  
		  return SpecialFolder.Desktop.Child("methodprofiler.log")
		End Function
	#tag EndMethod


	#tag Note, Name = About
		Purpose
		--------
		
		Use this class in all your methods that you like to track when they're invoked.
		Tracking doesn't only include the time when the method is entered but also
		when the method is exited. It does also show the time each method spent.
		
		This feature, along with indentation of the logged messages, allows you to tell
		very precisely which paths your code takes and where it spends its time.
		
		The output appears in Console.app (on OSX); on Windows, use the program
		"DbgView" to see the output. Optionally, the output can also be written to a file
		(which appears on the Desktop by default).
		
		How to use it
		------------
		
		At the top of your methods, add this line:
		
		  Dim mp as new MethodProfiler (CurrentMethodName)
		
		When running your app, look into the console output to see which methods
		get called in what order, and when they leave.
		
		"Legal"
		-------
		
		Written by Thomas Tempelmann, tempelmann@gmail.com
		Gifted to the public domain: Free to use, modify and own by everyone.
		
	#tag EndNote


	#tag Property, Flags = &h21
		Private Shared gOutFile As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared gTimeSum() As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Set this to -1 to disable any logging through this class
			Set to 0 or higher to allow logging
		#tag EndNote
		Shared LogDepth As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mName As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTime As Double
	#tag EndProperty


	#tag Constant, Name = AlwaysWriteToFile, Type = Boolean, Dynamic = False, Default = \"True", Scope = Public
	#tag EndConstant

	#tag Constant, Name = Enabled, Type = Boolean, Dynamic = False, Default = \"False", Scope = Public
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
			InitialValue="2147483648"
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
	#tag EndViewBehavior
End Class
#tag EndClass
