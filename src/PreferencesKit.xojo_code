#tag Module
Protected Module PreferencesKit
	#tag Method, Flags = &h1, Description = 52657475726E7320746865206D6F64756C6527732076657273696F6E206E756D626572206173206120737472696E6720696E2074686520666F726D61743A20226D616A6F722E6D696E6F722E627567222E
		Protected Function Version() As String
		  ///
		  ' Returns the module's version number as a string in the format: "major.minor.bug".
		  ///
		  
		  Return Str(VERSION_MAJOR) + "." + Str(VERSION_MINOR) + "." + Str(VERSION_BUG)
		  
		End Function
	#tag EndMethod


	#tag Constant, Name = VERSION_BUG, Type = Double, Dynamic = False, Default = \"0", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = VERSION_MAJOR, Type = Double, Dynamic = False, Default = \"2", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = VERSION_MINOR, Type = Double, Dynamic = False, Default = \"0", Scope = Protected
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
	#tag EndViewBehavior
End Module
#tag EndModule
