﻿package net.rezmason.engram.menus {		// IMPORT STATEMENTS	import flash.events.MouseEvent;		import net.rezmason.engram.URLs;	import net.rezmason.engram.IController;	import net.rezmason.engram.IView;	import net.rezmason.utils.clickToURL;		public final class AboutBox extends MenuBase {						public function AboutBox(__controller:IController, __view:IView):void {						btnReturn.addEventListener(MouseEvent.CLICK, __controller.showLast);						_defaultYes = _defaultNo = btnReturn;			clickToURL(rmLinkButton, URLs.RM_URL);		}	}}