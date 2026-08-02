function onUse(player, item, fromPosition, target, toPosition, isHotkey)
  -- itemid represents charm? We check custom attribute
  local charmName = item:getAttribute(ITEM_ATTRIBUTE_DESCRIPTION) or "Small Charm"
  D2C.equipCharm(player, {name=charmName})
  return true
end
