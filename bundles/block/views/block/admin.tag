<block-admin-page>
  <div class="block-admin">

    <!-- title -->
    <admin-title description="Manage Block">
      <yield to="right">
        <a href="/admin/block/create" class="btn btn-lg btn-success">
          Create
        </a>
      </yield>
    </admin-title>
    <!-- / title -->

    <!-- claim grid page -->
    <grid ref="grid" grid={ opts.grid } table-class="table table-bordered table-striped" title="Block Grid" />
    <!-- / claim grid page -->
  </div>
</block-admin-page>
