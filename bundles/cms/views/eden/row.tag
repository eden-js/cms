<eden-row class={ 'row row-eq-height eden-dropzone' }>
  <span class="eden-dropzone-label">
    Row
  </span>
  <eden-add type="left" onclick={ opts.onAddBlock } way="unshift" placement={ opts.placement + '.children' } />
  
  <div each={ child, a in opts.el.children || [] } data-is={ child.tag || 'eden-loading' } on-add-block={ opts.onAddBlock } el={ child } i={ a } placement={ opts.placement + '.children.' + opts.i } />
  
  <eden-add type="right" onclick={ opts.onAddBlock } way="push" placement={ opts.placement + '.children' } />
</eden-row>
