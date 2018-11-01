<block-admin-remove-page>
  <div class="page page-admin">
    <form method="post" action="/admin/block/{ opts.item.id }/remove">
      <input if={ opts.redirect } name="redirect" value={ opts.redirect } type="hidden" />
      <div class="card">
        <div class="card-body">
          <p>
            Are you sure you want to delete <b>{ opts.item.placement }</b>?
          </p>
        </div>
        <div class="card-footer text-right">
          <button type="submit" class="btn btn-success btn-card">Remove Block</button>
        </div>
      </div>
    </form>
  </div>
</block-admin-remove-page>
