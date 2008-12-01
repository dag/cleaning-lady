begin
  require 'minigems'
  gem 'nokogiri'
rescue LoadError
  begin
    require 'rubygems'
    gem 'nokogiri'
  rescue LoadError
  end
end

require 'nokogiri'

class CleaningLady
  SUBSTITUTES = {
    :b => [:strong, {}],
  }.freeze

  WHITELIST = {
    :p => [],
    :strong => [],
  }.freeze

  BLACKLIST = {
    :script => nil,
  }.freeze

  @substitutes = SUBSTITUTES.dup
  @whitelist = WHITELIST.dup
  @blacklist = BLACKLIST.dup

  class << self
    attr_reader :substitutes, :whitelist, :blacklist
  end

  attr_reader :substitutes, :whitelist, :blacklist

  def initialize(stringable)
    @substitutes = self.class.substitutes.dup
    @whitelist = self.class.whitelist.dup
    @blacklist = self.class.blacklist.dup
    @string = String(stringable)
  end

  def wellformed
    @wellformed ||= String(nodes_for(@string).children)
  end

  def substituted
    nodes = nodes_for(wellformed)
    substitute_on(nodes, :root)
    String(nodes.children)
  end

  def white
    nodes = nodes_for(substituted)
    whitelist_on(nodes, :root)
    String(nodes.children)
  end

  def black
    nodes = nodes_for(substituted)
    blacklist_on(nodes, :root)
    String(nodes.children)
  end

  private

  def nodes_for(str)
    Nokogiri::XML("<div>#{str}</div>").root
  end

  def substitute_on(node, root=false)
    name = node.name.to_sym
    unless root
      if @substitutes.has_key? name
        node.name = String(@substitutes[name][0])
        @substitutes[name][1].each do |old, new|
          if node.attributes[String(old)]
            node.set_attribute(String(new), node.attributes[String(old)])
            node.remove_attribute(old)
          end
        end
      end
    end
    node.children.each do |child|
      substitute_on(child) unless child.is_a? Nokogiri::XML::Text
    end
  end

  def whitelist_on(node, root=false)
    name = node.name.to_sym
    unless root
      unless @whitelist.has_key? name
        node.remove
      else
        node.attributes.each_key do |attribute|
          unless @whitelist[name].include? attribute
            node.remove_attribute(attribute)
          end
        end
      end
    end
    node.children.each do |child|
      whitelist_on(child) unless child.is_a? Nokogiri::XML::Text
    end if node
  end

  def blacklist_on(node, root=false)
    name = node.name.to_sym
    unless root
      if @blacklist.has_key? name
        if @blacklist[name].nil?
          node.remove
        else
          @blacklist[name].each do |attribute|
            node.remove_attribute(attribute)
          end
        end
      end
    end
    node.children.each do |child|
      blacklist_on(child) unless child.is_a? Nokogiri::XML::Text
    end if node
  end
end
