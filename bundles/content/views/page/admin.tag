<page-admin-page>
  <div class="content-admin">

    <!-- title -->
    <admin-title description="Manage Pages">
      <yield to="right">
        <a href="/admin/page/create" class="btn btn-lg btn-success">
          Create
        </a>
      </yield>
    </admin-title>
    <!-- / title -->

    <!-- claim grid page -->
    <grid ref="grid" grid={ opts.grid } table-class="table table-bordered table-striped" title="Page Grid" />
    <!-- / claim grid page -->
  </div>
</page-admin-page>
