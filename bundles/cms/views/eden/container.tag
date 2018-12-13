<eden-container class="container{ opts.type ? '-' + opts.type : '' } { opts.class } eden-dropzone">
  <span class="eden-dropzone-label">
    Container
  </span>
  <eden-add type="top" onclick={ opts.onAddBlock } way="unshift" placement={ opts.placement + '.children' } />
  
  <div each={ child, a in opts.el.children || [] } data-is={ child.tag || 'eden-loading' } on-add-block={ opts.onAddBlock } el={ child } i={ a } placement={ opts.placement + '.children.' + opts.i } />
  
  <eden-add type="bottom" onclick={ opts.onAddBlock } way="push" placement={ opts.placement + '.children' } />
</eden-container>
