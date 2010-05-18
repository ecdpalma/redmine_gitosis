if defined? map
  map.resources :public_keys, :controller => 'gitosis_public_keys', :path_prefix => 'my'
else
  ActionController::Routing::Routes.draw do |map|
    map.resources :public_keys, :controller => 'gitosis_public_keys', :path_prefix => 'my'
  end
end