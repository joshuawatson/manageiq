class TreeBuilderConfigurationManagerConfiguredSystems < TreeBuilder
  attr_reader :tree_nodes

  private

  def tree_init_options(_tree_name)
    {:leaf => "ConfiguredSystem"}
  end

  def set_locals_for_render
    locals = super
    locals.merge!(:autoload => true, :id_prefix => 'cs_')
  end

  def root_options
    [t = _("All Configured Systems"), t]
  end

  # Get root nodes count/array for explorer tree
  def x_get_tree_roots(count_only, _options)
    objects = []
    objects.push(:id            => "csf",
                 :text          => _("%{name} Configured Systems") % {:name => ui_lookup(:ui_title => 'foreman')},
                 :image         => "folder",
                 :tip           => _("%{name} Configured Systems") % {:name => ui_lookup(:ui_title => 'foreman')},
                 :load_children => true)
    objects.push(:id            => "csa",
                 :text          => _("Ansible Tower Configured Systems"),
                 :image         => "folder",
                 :tip           => _("Ansible Tower Configured Systems"),
                 :load_children => true)
    objects.push(:id          => "global",
                 :text        => _("Global Filters"),
                 :image       => "folder",
                 :tip         => _("Global Shared Filters"),
                 :cfmeNoClick => true)
    objects.push(:id          => "my",
                 :text        => _("My Filters"),
                 :image       => "folder",
                 :tip         => _("My Personal Filters"),
                 :cfmeNoClick => true)
    count_only_or_objects(count_only, objects, nil)
  end

  def x_get_tree_custom_kids(object, count_only, options)
    objects = x_get_search_results(object, options[:leaf])
    count_only ? objects.length : objects
  end

  def x_get_search_results(object, leaf)
    case object[:id]
    when "global" # Global filters
      x_get_global_filter_search_results(leaf)
    when "my"     # My filters
      x_get_my_filter_search_results(leaf)
    end
  end

  def x_get_global_filter_search_results(leaf)
    MiqSearch.where(:db => leaf).visible_to_all.sort_by { |a| a.description.downcase }
  end

  def x_get_my_filter_search_results(leaf)
    MiqSearch.where(:db => leaf, :search_type => "user", :search_key => User.current_user.userid)
      .sort_by { |a| a.description.downcase }
  end
end
