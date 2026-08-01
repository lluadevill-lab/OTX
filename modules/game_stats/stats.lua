ui = nil
updateEvent = nil

function init()
  ui = g_ui.loadUI('stats', modules.game_interface.getMapPanel())
  
  -- CORREÇÃO: Verifica se o módulo client_options existe antes de tentar usar
  if modules.client_options then
      if modules.client_options.getOption and not modules.client_options.getOption("showPing") then
        if ui.fps then ui.fps:hide() end
      end
      if modules.client_options.getOption and not modules.client_options.getOption("showFps") then
        if ui.ping then ui.ping:hide() end
      end
  end
  
  updateEvent = scheduleEvent(update, 200)
end

function terminate()
  if updateEvent then
    removeEvent(updateEvent)
    updateEvent = nil
  end
  if ui then
    ui:destroy()
    ui = nil
  end
end

function update()
  updateEvent = scheduleEvent(update, 500)
  if not ui or ui:isHidden() then return end

  local fps = g_app.getFps()
  if ui.fps then
    ui.fps:setText('FPS: ' .. fps)
  end

  local ping = g_game.getPing()
  if g_proxy and g_proxy.getPing() > 0 then
    ping = g_proxy.getPing()
  end
  
  if ui.ping then
      local text = 'Ping: '
      local color
      if ping < 0 then
        text = text .. "??"
        color = 'yellow'
      else
        text = text .. ping .. ' ms'
        if ping >= 500 then
          color = 'red'
        elseif ping >= 250 then
          color = 'yellow'
        else
          color = 'green'
        end
      end
      ui.ping:setText(text)
      ui.ping:setColor(color)
  end
end

function show()
  if ui then ui:setVisible(true) end
end

function hide()
  if ui then ui:setVisible(false) end
end