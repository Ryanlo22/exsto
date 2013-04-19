--[[
	Exsto
	Copyright (C) 2010  Prefanatic

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

--[[ -----------------------------------
	Category:  Script Loading
     ----------------------------------- ]]
	
	exstoClient( "fel.lua" )
	
	-- Load our derma controls
	exstoClientFolder( "menu/controls" )
	
	exstoClient( "sh_enums.lua" )
	exstoClient( "menu/cl_menu_skin_main.lua" )
	exstoClient( "menu/cl_menu_skin_quick.lua" )
	exstoClient( "menu/cl_derma.lua" )
	exstoClient( "menu/cl_anim.lua" )
	exstoClient( "sh_tables.lua" )
	exstoClient( "sh_umsg_core.lua" )
	exstoClient( "sh_umsg.lua" )
	exstoClient( "sh_print.lua" )
	exstoClient( "sh_variables.lua" )
	exstoClient( "menu/cl_menu.lua" )
	exstoClient( "menu/cl_page.lua" )
	exstoClient( "menu/cl_quickmenu.lua" )
	exstoClient( "menu/cl_pagelist.lua" )
	exstoClient( "cl_menu.lua" )
	exstoClient( "sh_access.lua" )
	exstoClient( "sh_plugin_metatable.lua" )
	exstoClient( "sh_plugins.lua" )
	--exstoClient( "sh_cloud.lua" )
	
	-- I don't know why or how, but sometimes LocalPlayer is completely valid BEFORE clientside actually finishes a load....
	-- SO!  Lets check.  If we're good, we good.  If not, lets make sure we GET good.
	if LocalPlayer() and IsValid( LocalPlayer() ) then
		hook.Call( "ExClientLoading" )
		exsto.CreateSender( "ExClientLoad" ):Send()
	else
	
		hook.Add( "OnEntityCreated", "ExPlayerCheck", function( ent )
			print( ent, ent == LocalPlayer() )
			if ent == LocalPlayer() and IsValid( ent ) then
				hook.Call( "ExClientLoading" )
				exsto.CreateSender( "ExClientLoading" ):Send()
				hook.Remove( "OnEntityCreated", "ExPlayerCheck" )
			end
		end )
	end
	
	hook.Add( "ExReceivedPlugSettings", "ExInitCLPlugs", function()
		if #exsto.Plugins == 0 then
			exsto.LoadPlugins()
			exsto.InitPlugins()
			
			-- Legacy
			hook.Call( "ExPluginsReady" )
			exsto.CreateSender( "ExClientReady" ):Send()
		else
			-- We just want to poll a reload of plugins if one changed or not.
			for _, plug in ipairs( exsto.Plugins ) do
				plug:CheckStatus()
			end
		end
	end )
	
	local seconds = SysTime() - exsto.StartTime
	MsgC( Color( 146, 232, 136, 255 ), "Exsto load finished.  Waiting for server to initiate plugin load.\n"	)