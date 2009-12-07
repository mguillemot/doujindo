module BlogHelper
  def blog_index_nav
    [ [ t('blog.index.nav'), { :controller => 'blog', :action => 'index' } ] ]
  end

  def blog_post_nav(post)
    nav = blog_index_nav
    nav << [ post.title, { :controller => 'blog', :action => 'view', :ident => post.ident } ]
  end
end
