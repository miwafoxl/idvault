# GNU General Public License, version 2 (GPL-2.0-only) notice
# ---------------------------------------------------------------
# InlinkButton.gd
# ---------------------------------------------------------------
# Copyright (C) 2026   Amanda Severo   Contact: miwafoxl@proton.me
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, see https://www.gnu.org/licenses/.

extends PanelContainer
class_name DefaultUI_InlinkButton

@export var alias: String
@export var title: String
@export var count: int = 0

var related_item: Item = null
var linker_item: Item = null

func update() -> void:
	if not title:
		title = related_item.id
	%TXT_TITLE.set_text(title)
	%TXT_COUNT.set_text(str(count))
	if alias: 
		%TXT_ALIAS.set_text("%s →" % alias)
		%TXT_ALIAS.set_visible(true)
	else:
		%TXT_ALIAS.set_visible(false)
