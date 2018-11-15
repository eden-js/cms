<block-view-grid>
  <block-view on-refresh={ opts.onRefresh } block={ opts.block } data={ opts.data } on-grid-state={ onGridState } ref="block" class="d-block pb-3 h-100">
    <yield to="header">

      <i if={ !(opts.data.title || '').length }>Untitled { opts.data.name }</i>
      { opts.data.title }

    </yield>
    <yield to="body">
      <div class="card-body">
        <grid ref="grid" grid={ opts.data.grid } table-class="table table-bordered table-striped" title={ opts.data.title || opts.block.title } />
      </div>
    </yield>
  </block-view>

  <script>

  </script>
</block-view-grid>
