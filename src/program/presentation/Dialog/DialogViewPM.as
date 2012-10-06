package program.presentation.Dialog
{
	import com.examyes.flex.tools.ExtJS;
	import com.examyes.flex.tools.Utils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.List;
	import mx.core.IFactory;
	import mx.logging.*;
	import mx.managers.PopUpManager;
	
	import program.application.message.CheckBoxChangedMessage;
	import program.application.message.DialogMessage;
	import program.application.message.FriendListMessage;
	import program.application.message.LoginMessage;
	import program.application.message.SocketMessage;
	import program.domain.ClientInfo;
	import program.domain.FriendInfo;
	import program.domain.Group;
	import program.domain.User;
	import program.domain.UserInfo;
	import program.domain.builder.ProtocolBuilder;
	import program.presentation.Dialog.ItemRender.DiscussViewItemRenderer;
	import program.presentation.Dialog.NavigatorContent.DialogNavigator;
	import program.presentation.Dialog.NavigatorContent.DiscussListNavigator;
	import program.presentation.Dialog.PobUpDialog.DiscussGroupConfigDialog;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	import spark.components.NavigatorContent;
	import spark.components.Panel;

	public class DialogViewPM
	{
		private var LOG:ILogger = Utils.getLogger(this);
		[Bindable]
		public var privateChatClient:User = new User("","").setUid("");
		[Bindable]
		public var privateChatCheckBoxEnable:Boolean = false;
		[Bindable]
		public var friendList:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var clientList:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		public var discussList:ArrayCollection = new ArrayCollection();
		public var discussListTmp:ArrayCollection = new ArrayCollection();
		[Bindable]
		public var onlineNum:String;
		
		[Inject]
		public var userInfo:UserInfo;
		
		private var idHashMap:Object = new Object();
		
		[MessageDispatcher]
		public var send:Function;
		
		
		public var dialogView:DialogView; 
		private var layerInited:Boolean = false;
		
		public function DialogViewPM()
		{

		}
		
		[Init]
		public function init():void
		{
			LOG.debug("Init");
		}
		
		[MessageHandler(selector="freshDialog")]
		public function freshDialogHandler(msg:DialogMessage):void
		{
			if(layerInited)
				send(new SocketMessage(SocketMessage.CONNECT_SOCKET_SERVER,""));
		}
		
		public function initComplete(_friendView:DialogView):void
		{
			dialogView = _friendView;
			layerInited = true;
			send(new SocketMessage(SocketMessage.CONNECT_SOCKET_SERVER,""));
		}
		
		public function clientListClickHandler(event:MouseEvent):void
		{
			var item:ClientInfo  = dialogView.userList.selectedItem as ClientInfo;
			if (item != null)
			{
				privateChatClient.setName(item.fname).setUid(item.fid);
				for(var i:int = 0;i<dialogView.tabContentTN.length;i++)
				{
					var navContent:DialogNavigator = (DialogNavigator)(dialogView.tabContentTN.getChildAt(i));
					if(navContent.label == item.fid.toString())
					{
						dialogView.tabContentTN.selectedIndex = i;
						break;
					}
				}
			}
			dialogView.tabOperatTN.selectedIndex = 0;
			this.privateChatCheckBoxEnable = false;
			dialogView.privateChatCB.selected = false;
			if(dialogView.privateChatClientTI.text != "" && dialogView.privateChatClientTI.text != userInfo.getUser().name)
			{
				this.privateChatCheckBoxEnable = true;
			}
		}
		
		public function friendListClickHandler(event:MouseEvent):void
		{
			var item:FriendInfo  = dialogView.friendList.selectedItem as FriendInfo;
			if (item != null)
			{
				dialogView.friendIdTI.text = item.fid;
				privateChatClient.setName(item.fname).setUid(item.fid);
				for(var i:int = 0;i<dialogView.tabContentTN.length;i++)
				{
					var navContent:DialogNavigator = (DialogNavigator)(dialogView.tabContentTN.getChildAt(i));
					if(navContent.label == item.fid.toString())
					{
						dialogView.tabContentTN.selectedIndex = i;
						break;
					}
				}
			}
		}
		
		public function getFriend(fid:String):FriendInfo
		{
			var t:FriendInfo = null;
			var idKey:String = fid ;
			t = friendList.getItemAt(idHashMap[idKey]) as FriendInfo;
			return t;
		}
		
		public function addFriend(fid:String):Boolean
		{
			var result:Boolean = false;
			var idKey:String = fid;
			
			if (friendList.length >= 5)
			{
				Alert.show("5个以上的终端并行分析会严重影响分析性能", "添加失败");
				result = false;
			}
			else if (idHashMap[idKey] == null && idKey.length != 0)
			{
				var friend:FriendInfo = new FriendInfo(fid,fid);
				friendList.addItem(friend);
				idHashMap[idKey] = friendList.length - 1;
				
				result = true;
			}
			
			return result;
		}
		
		public function removeFriend(fid:String):Boolean
		{
			var result:Boolean = false;
			var idKey:String = fid;
			
			if (idHashMap[idKey] != null)
			{
				friendList.removeItemAt(idHashMap[idKey]);
				idHashMap[idKey] = null;
				
				for (var i:int = 0; i < friendList.length; ++i)
				{
					var friend:FriendInfo = friendList.getItemAt(i) as FriendInfo;
					idHashMap[friend.fid] = i;
				}
				
				result = true;
			}
			
			return result;
		}
		
		public function createDiscussGroup():void
		{
			var confirmHandler: Function = function(e:Event):void
			{ 
				discussListTmp.removeAll();
				var groupName:String = e.currentTarget.DiscussGroupName.text;
				for(var i:int=0;i<clientList.length;i++)
				{
					var client:ClientInfo = (ClientInfo)(clientList[i])
					if(client.joinDiscussGroupCB)
					{
						discussListTmp.addItem(new User(client.fname,"").setUid(client.fid));
					}
				}
				var groups:ArrayCollection = new ArrayCollection();
				groups.addItem(new Group(groupName));
				dialogView.tabOperatTN.selectedIndex = 1;
				send(new SocketMessage(SocketMessage.CREATE_DISCUSS_GROUP,[groups,discussListTmp]));
			}
			
			var groupConfig:DiscussGroupConfigDialog = new DiscussGroupConfigDialog();
			groupConfig.addEventListener("DiscussGroupConfig", confirmHandler);
			PopUpManager.addPopUp(groupConfig,dialogView,true);
			PopUpManager.centerPopUp(groupConfig);	
		}
		
		public function sendMessage():void
		{
			var contentView:DialogNavigator = (DialogNavigator)(dialogView.tabContentTN.getChildAt(dialogView.tabContentTN.selectedIndex));
			var content:String = contentView.label;
			var arr:Array;
			if(content.substring(0,3) == "讨论组")
			{
				var groups:ArrayCollection = new ArrayCollection();
				groups.addItem(new Group(contentView.name));
				arr = [groups,dialogView.messageTI.text];
				send(new SocketMessage(SocketMessage.SEND_DISCUSS_GROUP_CONTENT,arr));
			}
			else
			{
				if(dialogView.privateChatCB.selected)
				{
					content = dialogView.messageTI.text;
					if(content != "")
					{
						var user:ArrayCollection = new ArrayCollection();
						user.addItem(new User(privateChatClient.name,"").setUid(privateChatClient.uid));
						arr = [user,content]
						send(new SocketMessage(SocketMessage.SEND_PRIVATE_CONTENT,arr));
					}
				}
				else
				{
					content = dialogView.messageTI.text;
					send(new SocketMessage(SocketMessage.SEND_PUBLIC_CONTENT,content));
				}
			}
		}
		
		[MessageHandler(selector="startDialogize")]
		public function startDialogizeHandler(msg:FriendListMessage):void
		{
			var navContent:DialogNavigator = new DialogNavigator();
			navContent.name = msg.fid;
			navContent.label = msg.fid;
			navContent.model.setTitle(msg.fname);
			navContent.percentHeight = 100;
			navContent.percentWidth = 100;
			dialogView.tabContentTN.addChild(navContent);
			
		}
		
		[MessageHandler(selector="connectSocketServerComplete")]
		public function connectSocketServerCompleteHandler(msg:DialogMessage):void
		{
			
		}
		
		[MessageHandler(selector="updateClientList")]
		public function updateClientListHandler(msg:SocketMessage):void
		{
			clientList.removeAll();
			var builder:ProtocolBuilder = msg.param as ProtocolBuilder;
			var users:ArrayCollection = builder.getUsers() as ArrayCollection;
			var sort:Sort = new Sort();
			sort.fields = [new SortField("uid")];
			users.sort = sort;
			users.refresh();
			
			for(var i:int=0;i<users.length;i += 1)
			{
				var user:User = users.getItemAt(i) as User;
				var clientInfo:ClientInfo = new ClientInfo(user.uid,user.name);
				//clientInfo.joinDiscussGroupCB = true;
				if(clientInfo.fid == userInfo.getUser().uid)
				{
					clientInfo.joinDiscussCBEnable = false;
					clientInfo.joinFriendBT = false;
					clientInfo.joinDiscussGroupCB = false;
					clientList.addItemAt(clientInfo,0);
					continue;
				}
				
				clientList.addItem(clientInfo);
			}
			clientList.sort
		}
		
		[MessageHandler(selector="receivedPublicContent")]
		public function publicContentHandler(msg:SocketMessage):void
		{
			for(var i:int=0;i<dialogView.tabContentTN.length;i++)
			{
				var navContent:DialogNavigator = (DialogNavigator)(dialogView.tabContentTN.getChildAt(i));
				if(navContent.label == "大厅" )
				{
					navContent.model.addLine((ProtocolBuilder)(msg.param).getContent());
				}
			}
		}
		
		[MessageHandler(selector="receivedDiscussGroupContent")]
		public function receivedDiscussGroupContentHandler(msg:SocketMessage):void
		{
			var builder:ProtocolBuilder = msg.param as ProtocolBuilder;
			var content:String = builder.getContent() as String;
			var groups:ArrayCollection = builder.getGroups() as ArrayCollection;
			var group_0_Name:String = (Group)(groups.getItemAt(0)).name;
			for(var i:int=0;i<dialogView.tabContentTN.length;i++)
			{
				var navContent:DialogNavigator = (DialogNavigator)(dialogView.tabContentTN.getChildAt(i));
				if(navContent.name == group_0_Name )
				{
					navContent.model.addLine(content);
				}
			}
		}
		
		[MessageHandler(selector="onlineNum")]
		public function onlineNumHandler(msg:SocketMessage):void
		{
			var builder:ProtocolBuilder = msg.param as ProtocolBuilder;
			onlineNum = builder.getContent() as String;
		}
		
		[MessageHandler(selector="updateDiscussGroupList")]
		public function updateDiscussGroupListHandler(msg:SocketMessage):void
		{
			var arrList:ArrayCollection = new ArrayCollection();
			var builder:ProtocolBuilder = msg.param as ProtocolBuilder;
			var users:ArrayCollection = builder.getUsers() as ArrayCollection;
			var groups:ArrayCollection = builder.getGroups() as ArrayCollection;
			var group_0_Name:String = (Group)(groups.getItemAt(0)).name;
			var index:int = -1;
			var navigator:DiscussListNavigator = null;
			for(var i:int=0;i<users.length;i += 1)
			{
				var user:User = users.getItemAt(i) as User;
				var clientInfo:ClientInfo = new ClientInfo(user.uid,user.name);
				arrList.addItem(clientInfo);
			}
			
			for(i=0;dialogView.discussGroupAD.getChildren()!=null && i<dialogView.discussGroupAD.getChildren().length;i++)
			{
				navigator = dialogView.discussGroupAD.getChildAt(i) as DiscussListNavigator;
				if(navigator.label.substr(0,navigator.label.indexOf("-")) == group_0_Name)
				{
					index = i;
					break;
				}
			}
			
			if(index>=0)
			{
				navigator = dialogView.discussGroupAD.getChildAt(i) as DiscussListNavigator;
				navigator.name = group_0_Name;
				navigator.label = group_0_Name+"----当前在线人数："+ users.length.toString();
				navigator.model.content = arrList;
			}
			else
			{
				navigator = new DiscussListNavigator();
				navigator.name = group_0_Name;
				navigator.label = group_0_Name+"----当前在线人数："+ users.length.toString();
				navigator.model.content = arrList;
				dialogView.discussGroupAD.addChild(navigator);
				
				var navContent:DialogNavigator = new DialogNavigator();
				navContent.name = group_0_Name;
				navContent.label = "讨论组："+group_0_Name;
				navContent.model.setTitle(group_0_Name);
				navContent.percentHeight = 100;
				navContent.percentWidth = 100;
				dialogView.tabContentTN.addChild(navContent);
				
				dialogView.tabOperatTN.selectedIndex = 1;
				dialogView.discussGroupAD.selectedIndex = dialogView.discussGroupAD.getChildren().length-1;
				dialogView.tabContentTN.selectedIndex = dialogView.tabContentTN.getChildren().length-1;
			}
		}
		
		[MessageHandler(selector="newdiscussGroupInviting")]
		public function newdiscussGroupInvitingHandler(msg:SocketMessage):void
		{
			var builder:ProtocolBuilder = msg.param as ProtocolBuilder;
			var users:ArrayCollection = builder.getUsers() as ArrayCollection;
			var groups:ArrayCollection = builder.getGroups() as ArrayCollection;
			var group_0_Name:String = (Group)(groups.getItemAt(0)).name;
			var user0:User = users.getItemAt(0) as User;
			
			var confirmHandler: Function = function(dlg_obj: Object):void
			{ 
				if(dlg_obj.detail == Alert.YES){ 
					
					var groups:ArrayCollection = new ArrayCollection();
					groups.addItem(new Group(group_0_Name));
					send(new SocketMessage(SocketMessage.AGREE_FOR_DISCUSS_GROUP_INVITING,groups));
				} 
			} 
			
			
			var confirmDlg: Object = Alert.show(user0.name+"邀请您加入讨论组"+group_0_Name, "确认", Alert.YES|Alert.NO, null, confirmHandler, null, Alert.YES); 
		}
		
		[MessageHandler(selector="logout")]
		public function logoutHandler(msg:LoginMessage):void
		{
			clientList.removeAll();
			friendList.removeAll();
			discussList.removeAll();
			for(var i:int=dialogView.tabContentTN.length-1;i>=0;i--)
			{
				var navContent:DialogNavigator = (DialogNavigator)(dialogView.tabContentTN.getChildAt(i));
				if(navContent.label != "大厅" )
				{
					dialogView.tabContentTN.removeChildAt(i);
				}
				else
				{
					navContent.model.removeContent();
				}
			}
			friendList.removeAll();
			clientList.removeAll();
			discussList.removeAll();
			discussListTmp.removeAll();
			onlineNum="当前聊天人数：0";
			dialogView.discussGroupAD.removeAllChildren();
			dialogView.tabOperatTN.selectedIndex = 0;
			dialogView.messageTI.text = "";
			dialogView.privateChatCB.selected = false;
			dialogView.privateChatClientTI.text = "";
		}
		
		[MessageHandler(selector="clientViewItemRenderer")]
		public function clientViewItemRendererHandler(msg:CheckBoxChangedMessage):void
		{
			for(var i:int=0;i<clientList.length;i++)
			{
				var clientInfo:ClientInfo = clientList.getItemAt(i) as ClientInfo;
				if(clientInfo.fid == msg.id )
				{
					clientInfo.joinDiscussGroupCB = !clientInfo.joinDiscussGroupCB;
				}
			}
		}
		
		public function logout():void
		{
			send(new LoginMessage(LoginMessage.LOGOUT));

		}
		
		public function exitDiscussGroup():void
		{
			if(dialogView.discussGroupAD.getChildren() == null || dialogView.discussGroupAD.getChildren().length == 0)
				return;
			var discussGroup:DiscussListNavigator = dialogView.discussGroupAD.getChildAt(dialogView.discussGroupAD.selectedIndex) as DiscussListNavigator;
			var groups:ArrayCollection = new ArrayCollection();
			groups.addItem(new Group(discussGroup.name));
			send(new SocketMessage(SocketMessage.EXIT_DISCUSS_GROUP,groups));
			for(var i:int=0;i<dialogView.tabContentTN.length;i++)
			{
				var navContent:DialogNavigator = (DialogNavigator)(dialogView.tabContentTN.getChildAt(i));
				if(navContent.name == discussGroup.name )
				{
					dialogView.tabContentTN.removeChildAt(i);
				}
			}
			dialogView.discussGroupAD.removeChild(discussGroup);
		}
	}
}