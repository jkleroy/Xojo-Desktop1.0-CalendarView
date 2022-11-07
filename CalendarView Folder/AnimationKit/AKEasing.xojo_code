#tag Module
Protected Module AKEasing
	#tag Method, Flags = &h1
		Protected Function easeInBack(time as double, beginningValue as double, changeInValue as double, duration as double, s as double = - 1) As double
		  
		  if s = -1 then
		    s = 1.70158
		  end if
		  
		  time = time / duration
		  
		  return ((((changeInValue * ((time))) * time) * (((s + 1) * time) - s)) + beginningValue)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeInBounce(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  return (changeInValue - easeOutBounce(duration - time, 0, changeInValue, duration)) + beginningValue
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeInCirc(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  time = time / duration
		  
		  return ((-changeInValue) * (sqrt(1 - (((time)) * time)) - 1)) + beginningValue
		  
		  'return (((-c) * (Math.sqrt(1 - (((t = t / d)) * t)) - 1)) + b);
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeInCubic(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  time = time / duration
		  
		  return ((((changeInValue  * ((time))) * time) * time) + beginningValue)
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeInElastic(time as double, beginningValue as double, changeInValue as double, duration as double, amplitude as double = - 1, period as double = - 1) As double
		  dim s as double
		  
		  if (time = 0) then
		    return beginningValue
		  end if
		  
		  time = time / duration
		  
		  if (time = 1) then
		    return beginningValue + changeInValue
		  end if
		  
		  if (period = -1) then
		    period = duration * .3
		  end if
		  
		  if (amplitude < abs(changeInValue)) then
		    amplitude = changeInValue
		    s = period / 4
		  else
		    s = ((period / (PI * 2)) * asin(changeInValue / amplitude))
		  end if
		  
		  time = time - 1
		  
		  return (-((amplitude * pow(2, 10 * ((time)))) * sin((((time * duration) - s) * (PI*2)) / period))) + beginningValue
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeInExpo(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  if time = 0 then
		    return beginningValue
		  else
		    return (changeInValue * pow(2, 10 * ((time / duration) - 1))) + beginningValue
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeInOutBack(time as double, beginningValue as double, changeInValue as double, duration as double, s as double = - 1) As double
		  
		  if s = -1 then
		    s = 1.70158
		  end if
		  
		  time = time / (duration / 2)
		  
		  if time < 1 then
		    s = s * 1.525
		    return (((changeInValue / 2) * ((time * time) * (((((s)) + 1) * time) - s))) + beginningValue)
		  end if
		  
		  time = time - 2
		  s = s * 1.525
		  
		  return  (((changeInValue / 2) * (((((time)) * time) * (((((s)) + 1) * time) + s)) + 2)) + beginningValue)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeInOutBounce(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  if time < (duration / 2) then
		    return (easeInBounce(time * 2, 0, changeInValue, duration) * .5) + beginningValue
		  end if
		  
		  return ((easeOutBounce((time * 2) - duration, 0, changeInValue, duration) * .5) + (changeInValue * .5)) + beginningValue
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeInOutCirc(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  time = time / (duration / 2)
		  
		  if time < 1 then
		    return (((-changeInValue) / 2) * (sqrt(1 - (time * time)) - 1)) + beginningValue
		  end if
		  
		  time = time - 2
		  
		  return ((changeInValue / 2) * (sqrt(1 - (time * time)) + 1)) + beginningValue
		  
		  'if (((t = t / (d / 2))) < 1) {
		  '   return ((((-c) / 2) * (Math.sqrt(1 - (t * t)) - 1)) + b);
		  '}
		  'return (((c / 2) * (Math.sqrt(1 - (((t = t - 2)) * t)) + 1)) + b);
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeInOutCubic(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  time = time / (duration / 2)
		  
		  if time < 1 then
		    return ((((changeInValue  / 2) * time) * time) * time) + beginningValue
		  end if
		  
		  time = time - 2
		  
		  return ((changeInValue  / 2) * (((time * time) * time) + 2)) + beginningValue
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeInOutElastic(time as double, beginningValue as double, changeInValue as double, duration as double, amplitude as double = 0, period as double = 0) As double
		  dim s as double
		  
		  if (time = 0) then
		    return beginningValue
		  end if
		  
		  time = time / (duration / 2)
		  
		  if (time = 2) then
		    return beginningValue + changeInValue
		  end if
		  
		  if (period = 0) then
		    period = duration * .45
		  end if
		  
		  if (amplitude < abs(changeInValue)) then
		    amplitude = changeInValue
		    s = period / 4
		  else
		    s = ((period / (PI * 2)) * asin(changeInValue / amplitude))
		  end if
		  
		  if (time < 1) then
		    time = time - 1
		    return ((-0.5 * ((amplitude * pow(2, 10 * ((time)))) * sin((((time * duration) - s) * (PI*2)) / period))) + beginningValue)
		  end if
		  
		  time = time - 1
		  return (((((amplitude * pow(2, -10 * ((time)))) * sin((((time * duration) - s) * (PI*2)) / period)) * 0.5) + changeInValue) + beginningValue)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeInOutExpo(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  if time = 0 then
		    return beginningValue
		  end if
		  
		  if time = duration then
		    return beginningValue + changeInValue
		  end if
		  
		  time = time / (duration / 2)
		  
		  if time < 1 then
		    return ((changeInValue / 2) * pow(2, 10 * (time - 1))) + beginningValue
		  end if
		  
		  return ((changeInValue / 2) * ((-pow(2, -10 * (time - 1))) + 2)) + beginningValue
		  
		  'if (t == 0) {
		  '   return (b);
		  '}
		  'if (t == d) {
		  '   return (b + c);
		  '}
		  'if (((t = t / (d / 2))) < 1) {
		  '   return (((c / 2) * Math.pow(2, 10 * (t - 1))) + b);
		  '}
		  'return (((c / 2) * ((-Math.pow(2, -10 * (--t))) + 2)) + b);
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeInOutQuad(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  time = (time / (duration / 2))
		  
		  if (time < 1) then
		    return ((((changeInValue / 2) * time) * time) + beginningValue)
		  end if
		  
		  return ((((-changeInValue) / 2) * (((time - 1) * (time - 3)) - 1)) + beginningValue)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeInOutQuart(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  time = time / (duration/2)
		  
		  if time < 1 then
		    return ((((( changeInValue / 2) * time) * time) * time) * time) + beginningValue
		  end if
		  
		  time = time - 2
		  return ((( -changeInValue) / 2) * ((((time * time) * time) * time) - 2)) + beginningValue
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeInOutQuint(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  time = time / (duration / 2)
		  
		  if time < 1 then
		    return ((((((changeInValue / 2) * time) * time) * time) * time) * time) + beginningValue
		  end if
		  
		  time = time - 2
		  
		  return ((changeInValue / 2) * (((((((time)) * time) * time) * time) * time) + 2)) + beginningValue
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeInOutSine(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  return (((-changeInValue) / 2) * (cos((PI * time) / duration) - 1)) + beginningValue
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeInQuad(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  return (((changeInValue * ((time/duration )))  * (time/duration )) + beginningValue)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeInQuart(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  time = time / duration
		  
		  return (((( changeInValue * time) * time) * time) * time) + beginningValue
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeInQuint(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  time = time / duration
		  
		  return (((((changeInValue * ((time))) * time) * time) * time) * time) + beginningValue
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeInSine(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  return (((( -changeInValue) * cos((time/duration) * (PI / 2))) + changeInValue) + beginningValue)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeOutBack(time as double, beginningValue as double, changeInValue as double, duration as double, s as double = - 1) As double
		  
		  if s = -1 then
		    s = 1.70158
		  end if
		  
		  time = (time / duration) - 1
		  
		  return ((changeInValue * (((((time)) * time) * (((s + 1) * time) + s)) + 1)) + beginningValue)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeOutBounce(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  time = time / duration
		  
		  if time < ( 1 / 2.75) then
		    
		    return (changeInValue * ((7.5625 * time) * time)) + beginningValue
		    
		  elseif time < (2 / 2.75) then
		    
		    time = time - (1.5/2.75)
		    return changeInValue * (7.5625*(time)*time + .75) + beginningValue
		    
		  elseif time < (2.5 / 2.75) then
		    
		    time = time - (2.25/2.75)
		    return (changeInValue * (((7.5625 * ((time))) * time) + 0.9375)) + beginningValue
		    
		  else
		    
		    time = time - (2.625/2.75)
		    return (changeInValue * (((7.5625 * ((time))) * time) + 0.984375)) + beginningValue
		    
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeOutCirc(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  time = (time / duration) - 1
		  
		  return (changeInValue * sqrt(1 - (time * time))) + beginningValue
		  
		  'return ((c * Math.sqrt(1 - (((t = (t / d) - 1)) * t))) + b);
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeOutCubic(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  time = (time / duration) - 1
		  
		  return (changeInValue  * (((((time)) * time) * time) + 1)) + beginningValue
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeOutElastic(time as double, beginningValue as double, changeInValue as double, duration as double, amplitude as double = 0, period as double = 0) As double
		  
		  dim s as double
		  
		  if (time = 0) then
		    return beginningValue
		  end if
		  
		  time = time / duration
		  
		  if (time = 1) then
		    return beginningValue + changeInValue
		  end if
		  
		  if (period = 0) then
		    period = duration * .3
		  end if
		  
		  if (amplitude < abs(changeInValue)) then
		    amplitude = changeInValue
		    s = period / 4
		  else
		    s = ((period / (PI * 2)) * asin(changeInValue / amplitude))
		  end if
		  
		  return (((amplitude * pow(2, -10 * time)) * sin((((time * duration) - s) * (PI*2)) / period)) + changeInValue) + beginningValue
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeOutExpo(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  if  time = duration then
		    return beginningValue + changeInValue
		  else
		    return (changeInValue * ((-pow(2, (-10 * time) / duration)) + 1)) + beginningValue
		  end if
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeOutQuad(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  return (((-changeInValue) * ((time / duration))) * ((time / duration) - 2.0)) + beginningValue
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeOutQuart(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  time = (time / duration ) - 1
		  
		  return ((-changeInValue) * ((((((time)) * time) * time) * time) - 1)) + beginningValue
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeOutQuint(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  time = (time / duration) - 1
		  
		  return (changeInValue * (((((time * time) * time) * time) * time) + 1)) + beginningValue
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function easeOutSine(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  return (changeInValue * sin((time/duration) * (PI / 2))) + beginningValue
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function getEaseValue(method as integer, time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  select case method
		    
		  case AKEasing.kLinearTween
		    return AKEasing.linearTween(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseInQuad
		    return AKEasing.easeInQuad(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseOutQuad
		    return AKEasing.easeOutQuad(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseInOutQuad
		    return AKEasing.easeInOutQuad(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseInCubic
		    return AKEasing.easeInCubic(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseOutCubic
		    return AKEasing.easeOutCubic(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseInOutCubic
		    return AKEasing.easeInOutCubic(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseInQuart
		    return AKEasing.easeInQuart(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseOutQuart
		    return AKEasing.easeOutQuart(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseInOutQuart
		    return AKEasing.easeInOutQuart(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseInQuint
		    return AKEasing.easeInQuint(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseOutQuint
		    return AKEasing.easeOutQuint(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseInOutQuint
		    return AKEasing.easeInOutQuint(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseInSine
		    return AKEasing.easeInSine(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseOutSine
		    return AKEasing.easeOutSine(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseInOutSine
		    return AKEasing.easeInOutSine(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseInExpo
		    return AKEasing.easeInExpo(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseOutExpo
		    return AKEasing.easeOutExpo(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseInOutExpo
		    return AKEasing.easeInOutExpo(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseInCirc
		    return AKEasing.easeInCirc(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseOutCirc
		    return AKEasing.easeOutCirc(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseInOutCirc
		    return AKEasing.easeInOutCirc(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseInElastic
		    return AKEasing.easeInElastic(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseOutElastic
		    return AKEasing.easeOutElastic(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseInOutElastic
		    return AKEasing.easeInOutElastic(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseInBack
		    return AKEasing.easeInBack(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseOutBack
		    return AKEasing.easeOutBack(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseInOutBack
		    return AKEasing.easeInOutBack(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseInBounce
		    return AKEasing.easeInBounce(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseOutBounce
		    return AKEasing.easeOutBounce(time, beginningValue, changeInValue, duration)
		    
		  case AKEasing.kEaseInOutBounce
		    return AKEasing.easeInOutBounce(time, beginningValue, changeInValue, duration)
		    
		  end Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function linearTween(time as double, beginningValue as double, changeInValue as double, duration as double) As double
		  
		  return  (((changeInValue * time) / duration) + beginningValue)
		End Function
	#tag EndMethod


	#tag Note, Name = README
		
		This module is a port of Robert Penner's Easing Equations to REALbasic by Stephen Tallent
		
		/*
		Easing Equations v1.5
		May 1, 2003
		(c) 2003 Robert Penner, all rights reserved.
		This work is subject to the terms in http://www.robertpenner.com/easing_terms_of_use.html.
		*/
		
		These tweening functions provide different flavors of
		math-based motion under a consistent API.
		
		Types of easing:
		
		Linear
		Quadratic
		Cubic
		Quartic
		Quintic
		Sinusoidal
		Exponential
		Circular
		Elastic
		Back
		Bounce
	#tag EndNote


	#tag Constant, Name = kEaseInBack, Type = Double, Dynamic = False, Default = \"25", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseInBounce, Type = Double, Dynamic = False, Default = \"28", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseInCirc, Type = Double, Dynamic = False, Default = \"19", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseInCubic, Type = Double, Dynamic = False, Default = \"4", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseInElastic, Type = Double, Dynamic = False, Default = \"22", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseInExpo, Type = Double, Dynamic = False, Default = \"16", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseInOutBack, Type = Double, Dynamic = False, Default = \"27", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseInOutBounce, Type = Double, Dynamic = False, Default = \"30", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseInOutCirc, Type = Double, Dynamic = False, Default = \"21", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseInOutCubic, Type = Double, Dynamic = False, Default = \"6", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseInOutElastic, Type = Double, Dynamic = False, Default = \"24", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseInOutExpo, Type = Double, Dynamic = False, Default = \"18", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseInOutQuad, Type = Double, Dynamic = False, Default = \"3", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseInOutQuart, Type = Double, Dynamic = False, Default = \"9", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseInOutQuint, Type = Double, Dynamic = False, Default = \"12", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseInOutSine, Type = Double, Dynamic = False, Default = \"15", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseInQuad, Type = Double, Dynamic = False, Default = \"1", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseInQuart, Type = Double, Dynamic = False, Default = \"7", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseInQuint, Type = Double, Dynamic = False, Default = \"10", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseInSine, Type = Double, Dynamic = False, Default = \"13", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseOutBack, Type = Double, Dynamic = False, Default = \"26", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseOutBounce, Type = Double, Dynamic = False, Default = \"29", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseOutCirc, Type = Double, Dynamic = False, Default = \"20", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseOutCubic, Type = Double, Dynamic = False, Default = \"5", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseOutElastic, Type = Double, Dynamic = False, Default = \"23", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseOutExpo, Type = Double, Dynamic = False, Default = \"17", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseOutQuad, Type = Double, Dynamic = False, Default = \"2", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseOutQuart, Type = Double, Dynamic = False, Default = \"8", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseOutQuint, Type = Double, Dynamic = False, Default = \"11", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kEaseOutSine, Type = Double, Dynamic = False, Default = \"14", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kLinearTween, Type = Double, Dynamic = False, Default = \"0", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = PI, Type = Double, Dynamic = False, Default = \"3.14159265358979323846264338327950", Scope = Protected
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
