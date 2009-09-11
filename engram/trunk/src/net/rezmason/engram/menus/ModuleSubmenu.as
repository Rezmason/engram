﻿package net.rezmason.engram.menus {		// IMPORT STATEMENTS	import flash.display.InteractiveObject;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.filters.GlowFilter;		import net.rezmason.display.Grid;	import net.rezmason.display.GridFill;	import net.rezmason.engram.Alerts;	import net.rezmason.engram.CommonSignals;	import net.rezmason.engram.display.AlertType;	import net.rezmason.engram.modules.ModuleLoader;	import net.rezmason.gui.AlertData;	import net.rezmason.gui.GUIEvent;	import net.rezmason.gui.GUISlider;	import net.rezmason.media.SoundManager;	public final class ModuleSubmenu extends SubmenuBase {				// CLASS PROPERTIES		private static const MARGIN:Number = 20;				// INSTANCE PROPERTIES		private var loaders:Array;		private var selectedLoader:ModuleLoader, currentLoader:ModuleLoader;		private var listGrid:Grid;		private var glow:GlowFilter = new GlowFilter(0xFFFFFF, 1.0, 8, 8, 10, 1);		private var soundManager:SoundManager = SoundManager.INSTANCE;		private var listElements:Array = [];		private var deleteModuleData:AlertData = Alerts.DELETE_MODULE.clone();				public function ModuleSubmenu(__settingsMenu:SettingsMenu):void {			super(__settingsMenu);						addColorChild(window);			addColorChild(background, 1);			addColorChild(toolbar, 1);			addColorChild(btnDelete, 1);			addColorChild(btnUpdate, 1);			addColorChild(btnUpdate, 1);			addColorChild(slider);			addColorChild(disabledSlider, 1);						btnUpdate.visible = false;			btnDelete.addEventListener(MouseEvent.CLICK, deleteModuleConfirm);			btnDelete.useHandCursor = true;			btnUpdate.useHandCursor = true;						disabledSlider.visible = false;						deleteModuleData.rightButtons[0].func = deleteModule;			deleteModuleData.rightButtons[1].func = spitModule;						slider.defaultPosition = 0;			slider.axis = GUISlider.VERTICAL_AXIS;			slider.scrollToMouse = true;			slider.encloseThumb = true;			slider.addEventListener(Event.CHANGE, scrollList);						listGrid = new Grid(listMask.width, 0, listMask.width * 0.7, MARGIN);			listGrid.x = listMask.x + listMask.width / 2 - listGrid.cellWidth * 0.5;			listGrid.fill = [GridFill.TOP_TO_BOTTOM];			listGrid.mask = listMask;			addChild(listGrid);		}				// GETTERS & SETTERS				override internal function get description():String {			return "Sometimes a module will have its own settings. You can access those here.";		}				internal function set list(value:Array):void {			loaders = value.slice();						var ike:int;			var _icon:InteractiveObject;			listGrid.clear();			for (ike = 0; ike < loaders.length; ike += 1) {				currentLoader = loaders[ike];				_icon = currentLoader.moduleIcon;				_icon.x = _icon.y = 0;				_icon.scaleX = _icon.scaleY = 1;				/*				var element:ModuleListElement = grabElement();				element.content = _icon;				element.text = currentLoader.module.title;				listGrid.place(element);				*/				listGrid.place(_icon);				_icon.addEventListener(MouseEvent.CLICK, clickResponder);				_icon.addEventListener(Event.ADDED, removeListeners);				_icon.addEventListener(Event.REMOVED, removeListeners);			}			for (ike = 0; ike < 20; ike += 1) {				/*				element = grabElement();				element.content = new DefaultIcon;				listGrid.place(element);				*/				listGrid.place(new DefaultIcon);			}		}				// PUBLIC METHODS				override internal function trigger(event:Event = null):void {					}				// PRIVATE & PROTECTED METHODS				override protected function prepare(event:Event = null):void {			disabledSlider.visible = (listGrid.height < listMask.height);			slider.position = slider.defaultPosition;			listGrid.y = listMask.y + MARGIN;			if (loaders) {				showPanel(loaders[0]);			}		}				override protected function reset(event:Event = null):void {					}				private function clickResponder(event:Event):void {			var index:int = getTargetIndex(event);			showPanel(loaders[index]);			soundManager.play("settingSound");		}				private function showPanel(ldr:ModuleLoader):void {			if (selectedLoader) {				selectedLoader.moduleIcon.filters = [];			}			selectedLoader = ldr;			selectedLoader.moduleIcon.filters = [glow];			descriptiveText.text = describe(selectedLoader);		}				private function describe(ldr:ModuleLoader):String {			var mod:Object = ldr.module;			var returnVal:String = mod.title;			returnVal += "   v" + mod.version;			returnVal += "   " + ldr.sizeString + "MB";			returnVal += "   by " + mod.author;			return returnVal;		}				private function scrollList(event:GUIEvent):void {			listGrid.y = MARGIN + listMask.y + (listMask.height - listGrid.height - 2 * MARGIN) * slider.position;		}				private function deleteModuleConfirm(event:Event):void {			soundManager.play("buttonSound")			if (selectedLoader) {				_command.freight = [null, deleteModuleData, AlertType.CANNOT_UNDO, true];				signal(CommonSignals.PROMPT);			}		}				private function grabElement():ModuleListElement {			if (listElements.length) {				return listElements.pop();			}			return new ModuleListElement();		}				private function deleteModule(event:Event = null):void {			if (selectedLoader) {				_command.freight = true;				signal(CommonSignals.REMOVE_MODULE);			}		}				private function spitModule(event:Event = null):void {			if (selectedLoader) {				_command.freight = false;				signal(CommonSignals.REMOVE_MODULE);			}		}				private function getTargetIndex(event:Event):int {			return listGrid.indexOf(event.currentTarget as InteractiveObject);		}				private function removeListeners(event:Event):void {			// not sure if this is enough			event.currentTarget.removeEventListener(MouseEvent.CLICK, clickResponder);			event.currentTarget.removeEventListener(Event.ADDED, removeListeners);			event.currentTarget.removeEventListener(Event.REMOVED, removeListeners);		}	}}